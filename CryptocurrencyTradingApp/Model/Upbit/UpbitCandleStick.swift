//
//  UpbitCandleStick.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/02/10.
//

import Foundation

struct UpbitCandleStick: Decodable {
    let openingPrice: Double
    let closingPrice: Double
    let lowPrice: Double
    let highPrice: Double
    let candleDateTime: Double
    let tradeVolume: Double
    
    enum CodingKeys: String, CodingKey {
        case openingPrice = "opening_price"
        case closingPrice = "trade_price"
        case lowPrice = "low_price"
        case highPrice = "high_price"
        case candleDateTime = "candle_date_time_kst"
        case tradeVolume = "candle_acc_trade_volume"
    }
}
