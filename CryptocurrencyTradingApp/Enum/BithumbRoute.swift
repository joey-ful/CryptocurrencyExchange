//
//  BithumbRoute.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/17.
//

import Foundation

enum BithumbRoute: Route {
    case all
    case coin
    
    var scheme: String {
        return "https"
    }
    
    var baseURL: String {
        return "//api.bithumb.com"
    }
    
    var path: String {
        return "/public"
    }
    
    func path(type: RestAPIType, symbol: String = "BTC_KRW", currency: Currency) -> String {
        switch self {
        case .all:
            return "\(path)/ticker/ALL_\(currency.path)"
        case .coin:
            return "\(path)/ticker/\(symbol)"
        }
    }
    
    enum Currency: String {
        case krw, btc
        
        var path: String {
            return self.rawValue.uppercased()
        }
    }
    
    enum RestAPIType: String {
        case ticker, orderbook
        case transactionHistory = "transaction_history"
        case assetStatus = "assetstatus"
    }
}
