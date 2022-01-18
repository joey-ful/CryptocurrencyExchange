//
//  RequestTik.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/01/17.
//

import Foundation

enum RequestTik: String, CaseIterable {
    case half = "30M"
    case one = "1H"
    case twelve = "12H"
    case twentyfour = "24H"
    case yesterday = "MID"
    
    var name: String {
        return self.rawValue
    }
    
    static var allItems: [String] {
        return Self.allCases.map {
            $0.name
        }
    }
}
