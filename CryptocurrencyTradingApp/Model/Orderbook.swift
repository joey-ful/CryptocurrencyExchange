//
//  Orderbook.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/28.
//

import Foundation

struct Orderbook: Decodable {
    let data: Data
    
    struct Data: Decodable {
        let date: String
        let paymentCurrency: String
        let coinSymbolString: String
        let bids: [Order]
        let asks: [Order]
        
        enum CodingKeys: String, CodingKey {
            case bids, asks
            case date = "timestamp"
            case paymentCurrency = "payment_currency"
            case coinSymbolString = "order_currency"
        }
    }
}
