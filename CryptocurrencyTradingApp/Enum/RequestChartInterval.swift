//
//  RequestChartInterval.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/01/21.
//

import Foundation

enum RequestChartInterval: String {
    case oneMinute = "/1m"
    case threeMinute = "/3m"
    case fiveMinute = "/5m"
    case tenMinute = "/10m"
    case thirtyMinute = "/30m"
    case oneHour = "/1h"
    case sixHour = "/6h"
    case twelveHour = "/12h"
    case twentyFourHour = "/24h"
}
