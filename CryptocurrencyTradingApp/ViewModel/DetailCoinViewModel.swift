//
//  DetailViewModel.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/01/30.
//

import Foundation
import UIKit.UIColor

class DetailCoinViewModel {
    private let restAPIManager = NetworkManager(networkable: NetworkModule())

    private let webSocketManager = WebSocketManager(of: .upbit)
    var userDefaults: [String] {
        UserDefaults.standard.object(forKey: "favorite") as? [String] ?? []
    }
    private var coinInfomation: UpbitWebsocketTicker = UpbitWebsocketTicker(market: "", accumulatedTradeValue: .zero, fluctuationRate: .zero, fluctuationAmount: .zero, volume: .zero, change: "", tradePrice: .zero) {
        didSet(newData) {
            NotificationCenter.default.post(name: .coinDetailNotificaion, object: ["detailCoin": newData])
        }
    }
    
    var sign: String {
        return coinInfomation.change.contains("FALL") ? "-" : "+"
    }
    
    var price: String {
        return "KRW " +  coinInfomation.tradePrice.description.toDecimal()
    }
    
    var lineColor: UIColor {
        return coinInfomation.change.contains("FALL") ? .blue : .red
    }
    
    var fluctuationRate: String {
        return (coinInfomation.fluctuationRate * .oneHundred).description.toDecimal().setFractionDigits(to: 2) + .percent
    }
    
    var fluctuationAmount: String {
        return sign + coinInfomation.fluctuationAmount.description.toDecimal()
    }
    
    init(market: UpbitMarket) {
        initiateViewModel(market)

    }
    
    func initiateViewModel(_ market: UpbitMarket) {
        webSocketManager.createWebSocket(of: .upbit)
        webSocketManager.connectWebSocket(parameter: UpbitWebSocketParameter(ticket: webSocketManager.uuid, .ticker, [market])) { [weak self] (parsedResult: Result<UpbitWebsocketTicker?, Error>) in
            guard case .success(let data) = parsedResult, let data = data else { return }
            self?.coinInfomation = data
        }
    }
    
    func addToUserDefaults(market: String) {
        var array = userDefaults
        array.append(market)
        UserDefaults.standard.set(array, forKey: "favorite")
    }
    
    func removeFromUserDefaults(market: String) {
        var array = userDefaults
        array.enumerated().forEach{ (index,target) in
            if target == market {
                array.remove(at: index)
                return
            }
        }
        UserDefaults.standard.set(array, forKey: "favorite")
    }
}
