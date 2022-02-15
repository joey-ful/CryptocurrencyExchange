//
//  TransactionHistory.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/25.
//

import Foundation

struct BithumbRestAPITransaction: Decodable {
    let data: [Transaction]
    
    struct Transaction: Decodable {
        let date: String
        let type: String
        let quantity: String
        let price: String
        let amount: String
        
        enum CodingKeys: String, CodingKey {
            case type, price
            case date = "transaction_date"
            case quantity = "units_traded"
            case amount = "total"
        }
    }
}
