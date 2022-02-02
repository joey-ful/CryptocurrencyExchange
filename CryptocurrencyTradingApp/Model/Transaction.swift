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
    let type: String?
    var price: String
    let prevPrice: String?
    var quantity: String?
    var amount: String?
    let date: String
    let upDown: String?
    
    init(symbol: String? = nil, type: String? = nil, price: String, prevPrice: String? = nil, quantity: String? = nil, amount: String? = nil, date: String, upDown: String? = nil) {
        self.symbol = symbol
        self.type = type
        self.price = price
        self.prevPrice = prevPrice
        self.quantity = quantity
        self.amount = amount
        self.date = date
        self.upDown = upDown
    }
    
    static func == (lhs: Transaction, rhs: Transaction) -> Bool {
        return lhs.id == rhs.id
        && lhs.price == rhs.price
        && lhs.quantity == rhs.quantity
        && lhs.amount == rhs.amount
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(price)
        hasher.combine(quantity)
        hasher.combine(amount)
    }
}
