//
//  UpbitTrade.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/02/10.
//

import Foundation

struct UpbitTrade: Decodable {
    let price: Double
    let prevPrice: Double
    let quantity: Double
    let timestamp: Double
    let type: String
    let cursor: Double
    
    enum CodingKeys: String, CodingKey {
        case price = "trade_price"
        case prevPrice = "prev_closing_price"
        case quantity = "trade_volume"
        case timestamp
        case type = "ask_bid"
        case cursor = "sequential_id"
    }
}
