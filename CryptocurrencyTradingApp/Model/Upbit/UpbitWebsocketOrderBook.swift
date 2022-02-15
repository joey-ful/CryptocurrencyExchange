//
//  UpbitWebsocketOrder.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/02/11.
//

import Foundation

struct UpbitWebsocketOrderBook: Decodable, WebSocketDataModel {
    let market: String
    let data: [OrderData]
    
    enum CodingKeys: String, CodingKey {
        case market = "code"
        case data = "orderbook_units"
    }
    struct OrderData: Decodable {
        let askSize: Double
        let bidSize: Double
        let askPrice: Double
        let bidPrice: Double
        
        enum CodingKeys: String, CodingKey {
            case askSize = "ask_size"
            case bidSize = "bid_size"
            case askPrice = "ask_price"
            case bidPrice = "bid_price"
        }
    }
}
