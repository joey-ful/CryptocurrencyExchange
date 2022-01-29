//
//  WebSocketOrderbook.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/29.
//

import Foundation

struct WebSocketOrderBook: WebSocketDataModel {
    let content: Data
    
    struct Data: Decodable {
        let list: [Order]
        
        struct Order: Decodable {
            let symbol: String
            let orderType: String
            let price: String
            let quantity: String
            let total: String
        }
    }
}
