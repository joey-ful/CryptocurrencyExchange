//
//  RequestChartInterval.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/01/21.
//

import Foundation

enum ChartInterval: String {
    case oneMinute
    case tenMinute
    case thirtyMinute
    case oneHour
    case twentyFourHour
    case week
    case month
    
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
        case .week:
            return 60 * 60 * 24 * 7
        case .month:
            return 60 * 60 * 24 * 30
        }
    }
    
    var upbitPath: String {
            switch self {
            case .oneMinute:
                return "minutes/1"
            case .tenMinute:
                return "minutes/10"
            case .thirtyMinute:
                return "minutes/30"
            case .oneHour:
                return "minutes/60"
            case .twentyFourHour:
                return "days"
            case .week:
                return "weeks"
            case .month:
                return "months"
            }
            
        }
    
    var bitThumbPath: String {
            switch self {
            case .oneMinute:
                return "/1m"
            case .tenMinute:
                return "/10m"
            case .thirtyMinute:
                return "/30m"
            case .oneHour:
                return "/1h"
            case .twentyFourHour:
                return "/24h"
            case .week:
                return ""
            case .month:
                return ""
            }
        }
}
