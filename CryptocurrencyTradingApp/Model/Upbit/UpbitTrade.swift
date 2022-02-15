//
//  UpbitTrade.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/02/10.
//

import Foundation

struct UpbitTrade: Decodable {
    let price: Double
    let quantity: Double
    let date: Double
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case price = "trade_price"
        case quantity = "trade_volume"
        case date = "timestamp"
        case type = "ask_bid"
    }
}
