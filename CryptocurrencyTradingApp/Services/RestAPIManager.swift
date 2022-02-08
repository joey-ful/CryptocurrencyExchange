//
//  RestAPIManager.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/17.
//

import UIKit

class RestAPIManager {
    private let rangeOfSuccessState = 200...299
    
    func fetch<T: Decodable>(type: RestAPIType,
                  paymentCurrency: RestAPIType.PaymentCurrency,
                  coin: CoinType? = nil,
                  chartIntervals: RequestChartInterval? = .twentyFourHour,
                  completion: @escaping (Result<T, Error>) -> Void)
    {
        guard coin != .unverified else {
            return completion(.failure(NetworkError.unverifiedCoin))
        }
        
        guard let urlString = type.urlString(paymentCurrency: paymentCurrency,
                                             coin: coin,
                                             chartIntervals: chartIntervals),
              let url = URL(string: urlString)
        else {
            return completion(.failure(NetworkError.invalidURL))
        }
        
        runDataTask(url: url, completionHandler: completion)
    }
    
    private func runDataTask<T: Decodable>(url: URL,
                 completionHandler: @escaping (Result<T, Error>) -> Void) {
        
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
            
            parse(data, completion: completionHandler)
            
        }.resume()
    }

    private func parse<T: Decodable>(_ data: Data, completion: @escaping (Result<T, Error>) -> Void) {
        do {
            let parsedData = try JSONDecoder().decode(T.self, from: data)
            DispatchQueue.main.async {
                completion(.success(parsedData))
            }
        } catch let error {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
}
