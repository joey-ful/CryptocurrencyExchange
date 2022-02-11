//
//  UpbitWebsocketTrade.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/02/11.
//

import Foundation

struct UpbitWebsocketTrade: Decodable, WebSocketDataModel {
    let market: String
    let type: String
    let price: Double
    let quantity: Double
    let dateTime: Double
    let upDown: String
    
    enum CodingKeys: String, CodingKey {
        case market = "code"
        case type = "ask_bid"
        case price = "trade_price"
        case quantity = "trade_volume"
        case dateTime = "trade_timestamp"
        case upDown = "change"
    }
}

