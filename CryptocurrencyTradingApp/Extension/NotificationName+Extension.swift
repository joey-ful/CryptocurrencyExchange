//
//  Notification.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/01/17.
//

import Foundation

extension Notification.Name {
    static let restAPITickerAllNotification = Notification.Name("restAPITickerAllNotification")
    static let tradeValueNotification = Notification.Name("tradeValueNotification")
    static let fluctuationNotification = Notification.Name("fluctuationNotification")
    static let currentPriceNotification = Notification.Name("currentPriceNotification")
    static let updateSortIconsNotification = Notification.Name("updateSortIconsNotification")

    static let restAPITickerNotification = Notification.Name("restAPITickerNotification")
    static let candlestickNotification = Notification.Name("candlestickNotification")
    static let restAPITransactionsNotification = Notification.Name("transactionsNotification")
    static let webSocketTransactionsNotification = Notification.Name("transactionsNotification")
}
