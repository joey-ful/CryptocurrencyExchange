//
//  RequestChartInterval.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/01/21.
//

import Foundation

enum RequestChartInterval: String {
    case oneMinute = "/1m"
    case tenMinute = "/10m"
    case thirtyMinute = "/30m"
    case oneHour = "/1h"
    case twentyFourHour = "/24h"
    
    var multiplier: Double {
        switch self {
        case .oneMinute:
            return 60
        case .tenMinute:
            return 60 * 10
        case .thirtyMinute:
            return 60 * 10 * 3
        case .oneHour:
            return 60 * 60
        case .twentyFourHour:
            return 60 * 60 * 24
        }
    }
}
