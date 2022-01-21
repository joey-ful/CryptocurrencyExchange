//
//  RestAPIManager.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/17.
//

import Foundation

class RestAPIManager {
    private let rangeOfSuccessState = 200...299
    
    func fetch(type: RestAPIType, paymentCurrency: RestAPIType.PaymentCurrency, coin: CoinType? = nil, chartIntervals: RequestChartInterval? = .twentyFourHour) {
        guard let urlString = type.urlString(paymentCurrency: paymentCurrency, coin: coin, chartIntervals: chartIntervals),
              let url = URL(string: urlString)
        else {
            return
        }
        runDataTask(url: url) { [weak self] result in
            switch result {
            case .success(let data):
                self?.parse(data, to: type)
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    private func runDataTask(url: URL,
                 completionHandler: @escaping (Result<Data, Error>) -> Void) {
        
        URLSession.shared.dataTask(with: url) { [self] (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completionHandler(.failure(error))
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  rangeOfSuccessState.contains(response.statusCode) else {
                      DispatchQueue.main.async {
                          completionHandler(.failure(NetworkError.badResponse))
                      }
                      return
                  }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(.failure(NetworkError.invalidData))
                }
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(.success(data))
            }
            
        }.resume()
    }

    private func parse(_ data: Data, to type: RestAPIType) {
        let parsingManager = ParsingManager()
        switch type {
        case .candlestick:
            let result = parsingManager.decode(from: data, to: CandleStick.self)
            filter(result)
        default:
            let result = parsingManager.decode(from: data, to: TickerAll.self)
            filter(result)
        }
    }
    
    private func filter<T: RestAPIDataModel>(_ parsedResult: Result<T, ParsingError>) {
        switch parsedResult {
        case .success(let parsedData):
            sendNotification(data: parsedData)
        case .failure(let error):
            assertionFailure(error.localizedDescription)
        }
    }
    
    private func sendNotification(data: RestAPIDataModel) {
        if let data = (data as? TickerAll)?.data {
            NotificationCenter.default.post(name: .restAPITickerAllNotification,
                                            object: nil,
                                            userInfo: ["data": mirror(data)])
        } else {
            if let data = (data as? CandleStick) {
                NotificationCenter.default.post(name: .candlestickNotification, object: nil, userInfo: ["data": data.data])
            }
        }
    }
    
    private func mirror(_ data: TickerAll.Data) -> [String: TickerAll.Data.Coin] {
        var tickerAllDictionary: [String: TickerAll.Data.Coin] = [:]
        let mirror = Mirror(reflecting: data)
        Array(mirror.children).forEach {
            if let coinName = $0.label,
               let coin = ($0.value as? TickerAll.Data.Coin) {
                tickerAllDictionary[coinName] = coin
            }
        }
        return tickerAllDictionary
    }
}
