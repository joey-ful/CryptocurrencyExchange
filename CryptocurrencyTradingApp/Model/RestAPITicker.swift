//
//  RestAPITicker.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/27.
//

import Foundation

struct RestAPITicker: Decodable {
    let data: Data
    
    struct Data: Decodable {
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
        let fluctuationRate24H: String
        let date: String
        
        enum CodingKeys: String, CodingKey {
            case openingPrice = "opening_price"
            case closingPrice = "closing_price"
            case minimumPrice = "min_price"
            case maxiumumPrice = "max_price"
            case unitsTraded = "units_traded"
            case tradeValue = "acc_trade_value"
            case previousClosingPrice = "prev_closing_price"
            case unitsTradedWithin24H = "units_traded_24H"
            case tradeValueWithin24H = "acc_trade_value_24H"
            case fluctuation24H = "fluctate_24H"
            case fluctuationRate24H = "fluctate_rate_24H"
            case date
        }
    }
}
