//
//  Transaction.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/25.
//

import Foundation

struct Transaction: Hashable {
    let id = UUID()
    let symbol: String?
    let type: String
    let price: String
    let quantity: String
    let amount: String
    let date: String
    let upDown: String?
    
    static func == (lhs: Transaction, rhs: Transaction) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
