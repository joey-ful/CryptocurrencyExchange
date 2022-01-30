//
//  MainListCoin.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/19.
//

import UIKit

struct Ticker: Hashable {
    let name: String
    let symbol: String
    var currentPrice: String
    var fluctuationRate: String
    var fluctuationAmount: String
    var tradeValue: String
    let openPrice: String?
    let highPrice: String?
    let lowPrice: String?
    let prevPrice: String?
    let quantity: String?
    
    static func == (lhs: Ticker, rhs: Ticker) -> Bool {
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

extension Ticker {
    init(name: String, symbol: String, currentPrice: String, fluctuationRate: String, fluctuationAmount: String, tradeValue: String) {
        self.name = name
        self.symbol = symbol
        self.currentPrice = currentPrice
        self.fluctuationRate = fluctuationRate
        self.fluctuationAmount = fluctuationAmount
        self.tradeValue = tradeValue
        self.openPrice = nil
        self.highPrice = nil
        self.lowPrice = nil
        self.prevPrice = nil
        self.quantity = nil
    }
    
    init() {
        self.name = ""
        self.symbol = ""
        self.currentPrice = ""
        self.fluctuationRate = ""
        self.fluctuationAmount = ""
        self.tradeValue = ""
        self.openPrice = nil
        self.highPrice = nil
        self.lowPrice = nil
        self.prevPrice = nil
        self.quantity = nil
    }
    
    init(openPrice: String, highPrice: String, lowPrice: String, prevPrice: String, quantity: String, tradeValue: String) {
        self.name = ""
        self.symbol = ""
        self.currentPrice = ""
        self.fluctuationRate = ""
        self.fluctuationAmount = ""
        self.tradeValue = tradeValue
        self.openPrice = openPrice
        self.highPrice = highPrice
        self.lowPrice = lowPrice
        self.prevPrice = prevPrice
        self.quantity = quantity
    }
    
    init(highPrice: String, tradeValue: String, fluctuationRate: String) {
        self.name = ""
        self.symbol = ""
        self.currentPrice = ""
        self.fluctuationRate = fluctuationRate
        self.fluctuationAmount = ""
        self.tradeValue = tradeValue
        self.openPrice = nil
        self.highPrice = highPrice
        self.lowPrice = nil
        self.prevPrice = nil
        self.quantity = nil
    }
    
    init(symbol: String, currentPrice: String, fluctuationAmount: String, fluctuationRate: String) {
        self.name = ""
        self.symbol = symbol
        self.currentPrice = currentPrice
        self.fluctuationRate = fluctuationRate
        self.fluctuationAmount = fluctuationAmount
        self.tradeValue = ""
        self.openPrice = nil
        self.highPrice = nil
        self.lowPrice = nil
        self.prevPrice = nil
        self.quantity = nil
    }
}
