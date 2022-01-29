//
//  MainListCoinViewModel.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/25.
//

import UIKit

class MainListCoinViewModel {
    private let coin: MainListCoin
    
    init(coin: MainListCoin) {
        self.coin = coin
    }
    
    var name: String {
        return coin.name
    }
    
    var symbol: String {
        return coin.symbol
    }
    
    var symbolForView: String {
        return coin.symbol.uppercased() + "/KRW"
    }

    var coinType: CoinType? {
        return CoinType.coin(symbol: coin.symbol.lowercased())
    }
    
    var currentPrice: String {
        return coin.currentPrice.toDecimal()
    }
    
    var sign: String {
        return coin.fluctuationRate.contains("-") ? "" : "+"
    }
    
    var fluctuationRate: String {
        return sign + coin.fluctuationRate + .percent
    }
    
    var fluctuationAmount: String {
        return sign + coin.fluctuationAmount.toDecimal()
    }
    
    var tradeValue: String {
        return coin.tradeValue.dividedByMillion() + .million
    }
}
