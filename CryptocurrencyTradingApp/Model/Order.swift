//
//  Order.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/28.
//

import Foundation

struct Order: Decodable, Hashable {
    let id = UUID()
    var price: String
    var quantity: String
    
    static func == (lhs: Order, rhs: Order) -> Bool {
        return lhs.id == rhs.id
        && lhs.price == rhs.price
        && lhs.quantity == rhs.quantity
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(price)
        hasher.combine(quantity)
    }
}
