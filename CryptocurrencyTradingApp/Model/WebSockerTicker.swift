//
//  WebSockerTicker.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/17.
//

import Foundation

struct WebSocketTicker: Decodable, WebSocketDataModel {
    let content: Ticker
}

struct Ticker: Decodable {
    let symbol: String
    let tickType: String
    let accumulatedTradeValue: String
    let fluctuationRate: String
    let fluctuationAmount: String
    
    enum CodingKeys: String, CodingKey {
        case symbol, tickType
        case accumulatedTradeValue = "value"
        case fluctuationRate = "chgRate"
        case fluctuationAmount = "chgAmt"
    }
}
