//
//  WebSocketTransaction.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/17.
//

import Foundation

struct WebSocketTransaction: Decodable, WebSocketDataModel {
    let content: Content
    
    struct Content: Decodable {
        let list: [Transaction]
    }
}

struct Transaction: Decodable {
    let symbol: String
    let type: String
    let price: String
    let quantity: String
    let amount: String
    let dateTime: String
    let upDown: String
    
    enum CodingKeys: String, CodingKey {
        case symbol
        case type = "buySellGb"
        case price = "contPrice"
        case quantity = "contQty"
        case amount = "contAmt"
        case dateTime = "contDtm"
        case upDown = "updn"
    }
}
