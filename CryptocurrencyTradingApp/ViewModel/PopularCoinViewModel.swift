//
//  PopularCoinViewModel.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/30.
//

import Foundation

class PopularCoinViewModel {
    private let popularCoin: Ticker
    
    init(popularCoin: Ticker) {
        self.popularCoin = popularCoin
    }
    
    var coinName: String {
        return popularCoin.name
    }
    
    var symbol: String {
        return popularCoin.symbol.uppercased()
    }
    
    var sign: String {
        return fluctuationRate.toDouble() < 0 ? "" : "+"
    }
    
    var price: String {
        return "KRW " +  popularCoin.currentPrice.toDecimal()
    }
    
    var fluctuationRate: String {
        return popularCoin.fluctuationRate.toDecimal().setFractionDigits(to: 2) + .percent
    }
}
