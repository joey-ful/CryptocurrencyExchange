//
//  UpbitTrade.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/02/10.
//

import Foundation

struct UpbitTrade: Decodable {
    let tradePrice: Double
    let tradeVolume: Double
    let tradeDate: String
    let askBid: String
    
    enum CodingKeys: String, CodingKey {
        case tradePrice = "trade_price"
        case tradeVolume = "trade_volume"
        case tradeDate = "timestamp"
        case askBid = "ask_bid"
    }
}
