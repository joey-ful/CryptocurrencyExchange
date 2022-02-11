//
//  UpbitWebSocketParameter.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/02/11.
//

import Foundation

struct UpbitWebSocketParameter: WebSocketParameter {
    var ticket: String
    let type: String
    let codes: [String]
    
    enum CodingKeys: String, CodingKey {
        case ticket, type, codes
    }
    
    init(ticket: UUID, _ type: RequestType, _ markets: [UpbitMarket]) {
        self.ticket = ticket.uuidString
        self.type = type.upbitName
        self.codes = markets.map { $0.market }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()

        var ticketContainer = container.nestedContainer(keyedBy: CodingKeys.self)
        try ticketContainer.encode(self.ticket, forKey: .ticket)

        var nestedContainer = container.nestedContainer(keyedBy: CodingKeys.self)
        try nestedContainer.encode(self.type, forKey: .type)
        try nestedContainer.encode(self.codes, forKey: .codes)
    }
}
