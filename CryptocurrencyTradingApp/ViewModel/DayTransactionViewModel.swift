//
//  DayTransactionViewModel.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/27.
//

import Foundation

class DayTransactionViewModel:TransactionViewModelType {
    private let dayTransaction: Transaction
    
    init(dayTransaction: Transaction) {
        self.dayTransaction = dayTransaction
    }
    
    var date: String {
        dayTransaction.date.toDate()
    }
    
    var closePrice: String {
        dayTransaction.price.toDecimal()
    }
    
    var fluctuationRate: String {
        let oldPrice = dayTransaction.prevPrice?.toDouble() ?? 0
        let newPrice = dayTransaction.price.toDouble()
        return ((newPrice - oldPrice) / newPrice).description.setFractionDigits(to: 2) + .percent
    }
    
    var quantity: String {
        return (dayTransaction.quantity ?? .zero).lose(from: ".")
    }
}
