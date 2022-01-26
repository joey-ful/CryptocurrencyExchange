//
//  MainListCoin.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/19.
//

import UIKit

struct MainListCoin: Hashable {
    let name: String
    let symbol: String
    var currentPrice: String
    var fluctuationRate: String
    var fluctuationAmount: String
    var tradeValue: String
    
    static func == (lhs: MainListCoin, rhs: MainListCoin) -> Bool {
        return lhs.name == rhs.name
        && lhs.symbol == rhs.symbol
        && lhs.currentPrice == rhs.currentPrice
        && lhs.fluctuationRate == rhs.fluctuationRate
        && lhs.fluctuationAmount == rhs.fluctuationAmount
        && lhs.tradeValue == rhs.tradeValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(symbol)
        hasher.combine(currentPrice)
        hasher.combine(fluctuationRate)
        hasher.combine(fluctuationAmount)
        hasher.combine(tradeValue)
    }
}
