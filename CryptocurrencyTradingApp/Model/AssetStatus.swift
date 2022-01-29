//
//  AssetStatus.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/29.
//

import Foundation

struct AssetStatus: Hashable {
    let coinName: String
    let symbol: String
    let withdraw: Int
    let deposit: Int
    
    static func == (lhs: AssetStatus, rhs: AssetStatus) -> Bool {
        return lhs.symbol == rhs.symbol
        && lhs.withdraw == rhs.withdraw
        && lhs.deposit == rhs.deposit
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(symbol)
        hasher.combine(withdraw)
        hasher.combine(deposit)
    }
}
