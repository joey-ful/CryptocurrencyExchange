//
//  Notification.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/01/17.
//

import Foundation

extension Notification.Name {
    static let webSocketTransactionNotification = Notification.Name("webSocketTransactionNotification")
    static let webSocketTickerNotification = Notification.Name("webSocketTickerNotification")
    static let webSocketTicker24HNotification = Notification.Name("webSocketTicker24HNotification")
    static let restAPITickerAllNotification = Notification.Name("restAPITickerAllNotification")
    static let candlestickNotification = Notification.Name("candlestickNotification")
}
