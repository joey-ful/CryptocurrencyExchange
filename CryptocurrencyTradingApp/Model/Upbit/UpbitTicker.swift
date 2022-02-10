//
//  UpbitTicker.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/02/10.
//

import Foundation

struct UpbitTicker: Decodable {
    let openingPrice: String
    let closingPrice: String
    let minimumPrice: String
    let maxiumumPrice: String
    let unitsTraded: String
    let tradeValue: String
    let previousClosingPrice: String
    let unitsTradedWithin24H: String
    let tradeValueWithin24H: String
    let fluctuation24H: String
    let fluctuationRate24HDividedByHundred: String
    let date: String
    
    enum CodingKeys: String, CodingKey {
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
