//
//  UpbitWebSocketParameter.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/02/11.
//

import Foundation

struct UpbitWebSocketParameter: WebSocketParameter {
    let type: String
    let markets: [String]
    
    init(_ type: RequestType, _ markets: [UpbitMarket]) {
        self.type = type.name
        self.markets = markets.map { $0.market }
    }
}
