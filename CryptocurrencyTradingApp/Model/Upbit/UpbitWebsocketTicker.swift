//
//  UpbitWebsocketTicker.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/02/11.
//

import Foundation

struct UpbitWebsocketTicker: Decodable, WebSocketDataModel {
    let market: String
    let tickType: String = "24H"
    let accumulatedTradeValue: Double
    let fluctuationRate: Double
    let fluctuationAmount: Double
    let volume: Double
    let change: String
    let tradePrice: Double

    enum CodingKeys: String, CodingKey {
        case market = "code"
        case tickType, change
        case accumulatedTradeValue = "acc_trade_price_24h"
        case fluctuationRate = "signed_change_rate"
        case fluctuationAmount = "signed_change_price"
        case volume = "acc_trade_volume_24h"
        case tradePrice = "trade_price"

    }
}


