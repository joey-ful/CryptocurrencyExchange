//
//  UpbitMarket.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/02/10.
//

import Foundation

struct UpbitMarket: Decodable {
    let market: String
    let koreanName: String
    let englishName: String
    
    enum CodingKeys: String, CodingKey {
        case market
        case koreanName = "korean_name"
        case englishName = "english_name"
    }
    
    var symbol: String {
            return market.split(separator: "-")[1].lowercased()
        }
}
