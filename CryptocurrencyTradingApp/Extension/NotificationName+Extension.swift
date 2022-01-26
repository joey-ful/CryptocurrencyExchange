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
    static let currentPriceNotification = Notification.Name("currentPriceNotification")
    static let updateSortIconsNotification = Notification.Name("updateSortIconsNotification")

    static let candlestickNotification = Notification.Name("candlestickNotification")
    static let sendCandleDataToViewModelNotification = Notification.Name("sendCandleDataToViewModelNotification")
    static let restAPITransactionsNotification = Notification.Name("transactionsNotification")
    static let webSocketTransactionsNotification = Notification.Name("transactionsNotification")
}
