//
//  UpbitCandleStick.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/02/10.
//

import Foundation

struct UpbitCandleStick: Decodable {
    let market: String
    let openingPrice: Double
    let closingPrice: Double
    let lowPrice: Double
    let highPrice: Double
    let candleDateTime: String
    let tradeVolume: Double
    let prevPrice: Double?
    let date: Double
    
    enum CodingKeys: String, CodingKey {
        case market
        case openingPrice = "opening_price"
        case closingPrice = "trade_price"
        case lowPrice = "low_price"
        case highPrice = "high_price"
        case candleDateTime = "candle_date_time_kst"
        case tradeVolume = "candle_acc_trade_volume"
        case prevPrice = "prev_closing_price"
        case date = "timestamp"
    }
}
