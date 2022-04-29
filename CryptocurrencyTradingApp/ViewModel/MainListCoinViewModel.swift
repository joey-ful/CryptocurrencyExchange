//
//  MainListCoinViewModel.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/25.
//

import UIKit

//class MainListCoinViewModel {
//    private let coin: Ticker
//    let hasRisen: Bool
//    
//    init(coin: Ticker, hasRisen: Bool = true) {
//        self.coin = coin
//        self.hasRisen = hasRisen
//    }
//    
//    var name: String {
//        return coin.name
//    }
//    
//    var symbol: String {
//        return coin.symbol
//    }
//    
//    var symbolForView: String {
//        return coin.symbol.uppercased() + "/KRW"
//    }
//
//    var coinType: CoinType? {
//        return CoinType.coin(symbol: coin.symbol.lowercased())
//    }
//    
//    var currentPrice: String {
//        return coin.currentPrice.toDecimal()
//    }
//    
//    var sign: String {
//        return coin.fluctuationRate.contains("-") ? "" : "+"
//    }
//    
//    var fluctuationRate: String {
//        return sign + coin.fluctuationRate.setFractionDigits(to: 2) + .percent
//    }
//    
//    var fluctuationAmount: String {
//        return sign + coin.fluctuationAmount.toDecimal()
//    }
//    
//    var tradeValue: String {
//        return coin.tradeValue.dividedByMillion() + .million
//    }
//}
