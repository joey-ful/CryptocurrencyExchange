//
//  TickerAll.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/17.
//

import Foundation

struct RestAPITickerAll: Decodable {
    let status: String
    let data: [String: TickerAllData]
    
    enum TickerAllData: Decodable {
        case coin(Coin)
        case date(String)
        
        init(from decoder: Decoder) throws {
             let container = try decoder.singleValueContainer()
             if let x = try? container.decode(Coin.self) {
                 self = .coin(x)
                 return
             }
             if let x = try? container.decode(String.self) {
                 self = .date(x)
                 return
             }
             throw DecodingError.typeMismatch(TickerAllData.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type"))
         }
    }
    
    struct Coin: Decodable, Hashable {
        let openingPrice, closingPrice, minPrice, maxPrice: String
        let unitsTraded, accTradeValue, prevClosingPrice, unitsTraded24H: String
        let accTradeValue24H, fluctate24H, fluctateRate24H: String
        
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
        }
        
        static func == (lhs: Coin, rhs: Coin) -> Bool {
            return lhs.openingPrice == rhs.openingPrice
            && lhs.closingPrice == rhs.closingPrice
            && lhs.unitsTraded == rhs.unitsTraded
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(openingPrice)
            hasher.combine(closingPrice)
            hasher.combine(unitsTraded)
        }
    }
}
