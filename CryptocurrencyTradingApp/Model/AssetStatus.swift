//
//  AssetStatus.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/29.
//

import Foundation

struct AssetStatus: Hashable {
    let id = UUID()
    let coinName: String
    let symbol: String
    let withdraw: Int
    let deposit: Int
    
    static func == (lhs: AssetStatus, rhs: AssetStatus) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
