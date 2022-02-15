//
//  UpbitTicker.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/02/10.
//

import Foundation

struct UpbitTicker: Decodable {
    let market: String
    let openingPrice: Double
    let closingPrice: Double
    let minimumPrice: Double
    let maxiumumPrice: Double
    let unitsTraded: Double
    let tradeValue: Double
    let previousClosingPrice: Double
    let unitsTradedWithin24H: Double
    let tradeValueWithin24H: Double
    let fluctuation24H: Double
    let fluctuationRate24HDividedByHundred: Double
    let date: Double
    
    enum CodingKeys: String, CodingKey {
        case market
        case openingPrice = "opening_price"
        case closingPrice = "trade_price"
        case minimumPrice = "low_price"
        case maxiumumPrice = "high_price"
        case unitsTraded = "acc_trade_volume"
        case tradeValue = "acc_trade_price"
        case previousClosingPrice = "prev_closing_price"
        case unitsTradedWithin24H = "acc_trade_volume_24h"
        case tradeValueWithin24H = "acc_trade_price_24h"
        case fluctuation24H = "signed_change_price"
        case fluctuationRate24HDividedByHundred = "signed_change_rate"
        case date = "timestamp"
    }
}
