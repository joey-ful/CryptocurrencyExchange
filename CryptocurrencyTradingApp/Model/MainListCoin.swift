//
//  MainListCoin.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/19.
//

import UIKit

struct MainListCoin: Hashable {
    let id = UUID()
    let name: String
    let symbol: String
    var currentPrice: String
    var fluctuationRate: String
    var fluctuationAmount: String
    var tradeValue: String
    
    static func == (lhs: MainListCoin, rhs: MainListCoin) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
