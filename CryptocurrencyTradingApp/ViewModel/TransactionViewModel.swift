//
//  TransactionViewModel.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/25.
//

import Foundation

class TransactionViewModel: TransactionViewModelType {
    private var transaction: Transaction
    
    init(transaction: Transaction) {
        self.transaction = transaction
    }
    
    var symbol: String? {
        return transaction.symbol?.lose(from: "-")
    }
    
    var type: String {
        switch transaction.type {
        case "1":
            return "bid"
        case "2":
            return "ask"
        default:
            return transaction.type ?? "1"
        }
    }
    
    var amount: String {
        return transaction.amount?.dividedByMillion() ?? .zero + .million
    }
    
    var time: String {
        return transaction.date.description.toDate(.fullTime)
    }
    
    var price: String {
        return transaction.price.toDecimal()
    }
    
    var quantity: String {
        return (transaction.quantity ?? .zero).setFractionDigits(to: 4)
    }
}
