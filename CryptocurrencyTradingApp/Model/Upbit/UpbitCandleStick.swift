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
    let tradeVolume: Double
    let prevPrice: Double?
    let timestamp: Double
    let dateKST: String
    
    enum CodingKeys: String, CodingKey {
        case market, timestamp
        case openingPrice = "opening_price"
        case closingPrice = "trade_price"
        case lowPrice = "low_price"
        case highPrice = "high_price"
        case tradeVolume = "candle_acc_trade_volume"
        case prevPrice = "prev_closing_price"
        case dateKST = "candle_date_time_kst"
    }
}
