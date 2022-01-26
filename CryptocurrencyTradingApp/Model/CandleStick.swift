//
//  CandleStick.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/01/19.
//

import Foundation

struct CandleStick: Codable, RestAPIDataModel {
    let status: String
    let data: [[CandleStickData]]
    
    enum CandleStickData: Codable {
        case integer(Int)
        case string(String)
        
        
        init(from decoder: Decoder) throws {
             let container = try decoder.singleValueContainer()
             if let x = try? container.decode(Int.self) {
                 self = .integer(x)
                 return
             }
             if let x = try? container.decode(String.self) {
                 self = .string(x)
                 return
             }
             throw DecodingError.typeMismatch(CandleStickData.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type"))
         }
    
    }
}


