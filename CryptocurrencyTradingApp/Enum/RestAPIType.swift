//
//  BithumbRoute.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/17.
//

import Foundation

enum RestAPIType: String {
    case ticker = "ticker/"
    case tickerAll = "ticker/ALL"
    case orderbook = "orderbook/"
    case orderbookAll = "orderbook/ALL"
    case transactionHistory = "transaction_history/"
    case assetStatus = "assetstatus/"
    case assetStatusAll = "assetstatus/ALL"

    var baseURL: String {
      return "https://api.bithumb.com/public/"
    }

    enum PaymentCurrency {
        case KRW
        case BTC
    }
    
    func urlString(paymentCurrency: PaymentCurrency, coin: CoinType? = nil) -> String? {
        let path = self.rawValue
        
        if path.contains("ALL") {
            return baseURL + path + "_\(paymentCurrency)"
        } else {
            guard let coin = coin else { return nil }
            return baseURL + path + "\(coin)_\(paymentCurrency)"
        }
    }
}