//
//  BithumbWebSocketMessage.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/01/17.
//

import Foundation

struct BithumbWebSocketParameter: Codable {
    let type: String
    let symbols: [String]
    let tickTypes: [String]?
    
    init(_ type: RequestType, _ symbols: [CoinType], _ tickTypes: [RequestTik]? = nil) {
        self.type = type.name
        self.symbols = symbols.map {$0.symbolKRW}
        self.tickTypes = tickTypes?.map { $0.name }
    }
}
