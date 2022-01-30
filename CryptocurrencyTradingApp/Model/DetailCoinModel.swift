//
//  DetailViewModel.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/01/30.
//

import Foundation

struct DetailCoinModel: Codable, WebSocketDataModel {
    let status: String
    let data: CoinData
    
    struct CoinData: Codable {
        let openingPrice, closingPrice, minPrice, maxPrice: String
        let unitsTraded, accTradeValue, prevClosingPrice, unitsTraded24H: String
        let accTradeValue24H, fluctate24H, fluctateRate24H, date: String
        
        enum CodingKeys: String, CodingKey {
            case openingPrice = "opening_price"
            case closingPrice = "closing_price"
            case minPrice = "min_price"
            case maxPrice = "max_price"
            case unitsTraded = "units_traded"
            case accTradeValue = "acc_trade_value"
            case prevClosingPrice = "prev_closing_price"
            case unitsTraded24H = "units_traded_24H"
            case accTradeValue24H = "acc_trade_value_24H"
            case fluctate24H = "fluctate_24H"
            case fluctateRate24H = "fluctate_rate_24H"
            case date
        }
    }
}
