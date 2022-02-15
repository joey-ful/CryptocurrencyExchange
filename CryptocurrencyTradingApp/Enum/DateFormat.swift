//
//  DateFormat.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/02/14.
//

import Foundation

enum DateFormat {
    case fullDate
    case fullDateTime
    case monthDay
    case fullTime
    
    var style: String {
        switch self {
        case .fullDate:
            return "yyyy-MM-dd"
        case .fullDateTime:
            return "yyyy-MM-dd HH:mm"
        case .monthDay:
            return "MM-dd"
        case .fullTime:
            return "HH:mm:ss"
        }
    }
}
