//
//  OrderViewModel.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/28.
//

import Foundation

class OrderViewModel {
    private let order: Order
    private weak var parent: OrdersViewModel?
    
    init(order: Order, parent: OrdersViewModel) {
        self.order = order
        self.parent = parent
    }
    
    var price: String {
        return order.price.toDecimal()
    }
    
    var quantity: String {
        return order.quantity.setFractionDigits(to: 4)
    }
    
    var orderType: String {
        return parent?.type(of: order) ?? "bid"
    }
    
    var ratio: Double {
        let maxQuantity = (orderType == "ask" ? parent?.maxAskQuantity : parent?.maxBidQuantity) ?? 1
        return quantity.toDouble() / maxQuantity
    }
    
    var max: Double? {
        return (orderType == "ask" ? parent?.maxAskQuantity : parent?.maxBidQuantity)
    }
}
