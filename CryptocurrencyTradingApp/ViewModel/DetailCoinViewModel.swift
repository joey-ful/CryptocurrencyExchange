//
//  DetailViewModel.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/01/30.
//

import Foundation

class DetailCoinViewModel {
    private let restAPIManager = RestAPIManager()
    private let webSocketManager = WebSocketManager()
    var userDefaults: [String] {
        UserDefaults.standard.object(forKey: "favorite") as? [String] ?? []
    }
    var coin: CoinType?
    var coinInfomation: Ticker? = nil {
        didSet(newData) {
            NotificationCenter.default.post(name: .coinDetailNotificaion, object: ["detailCoin": newData])
        }
    }
    
    init(coin: CoinType) {
        self.coin = coin
        initiateViewModel()
        updateFluctuation(coin: coin)
        updateCurrentPrice(coin: coin)
    }
    
    func initiateViewModel () {
        restAPIManager.fetch(type: .ticker, paymentCurrency: .KRW, coin: coin) { [weak self]  (parsedResult: Result<RestAPITicker, Error>) in
            switch parsedResult {
            case .success(let parsedData):
                self?.coinInfomation = Ticker(symbol: self?.coin?.rawValue ?? "btc", currentPrice: parsedData.data.closingPrice, fluctuationAmount: parsedData.data.fluctuation24H, fluctuationRate: parsedData.data.fluctuationRate24H)
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    func updateFluctuation(coin: CoinType) {
        webSocketManager.connectWebSocket(.ticker, [coin],[.yesterday]) { [weak self] (parsedResult: Result<WebSocketTicker?, Error>) in
            guard case .success(let data) = parsedResult, let dataContent = data?.content else {
                return
            }
            self?.coinInfomation?.fluctuationRate = dataContent.fluctuationRate
            self?.coinInfomation?.fluctuationAmount = dataContent.fluctuationAmount
            
        }
    }
    
    func updateCurrentPrice(coin: CoinType) {
        webSocketManager.connectWebSocket(.transaction, [coin],nil) { [weak self] (parsedResult: Result<WebSocketTransaction?, Error>) in

            guard case .success(let data) = parsedResult, let dataContent = data?.content.list else {
                return
            }
            dataContent.forEach {
                if $0.symbol.lose(from: "_").lowercased() == self?.coinInfomation?.symbol {
                    self?.coinInfomation?.currentPrice = $0.price
                }
            }
            
        }
    }
    
    func addToUserDefaults(coin: String) {
        var array = userDefaults
        array.append(coin)
        UserDefaults.standard.set(array, forKey: "favorite")
    }
    
    func removeFromUserDefaults(coin: String) {
        var array = userDefaults
        array.enumerated().forEach{ (index,target) in
            if target == coin {
                array.remove(at: index)
                return
            }
        }
        UserDefaults.standard.set(array, forKey: "favorite")
    }
}
