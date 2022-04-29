//
//  Notification.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/01/17.
//

import Foundation

extension Notification.Name {
    static let restAPITickerNotification = Notification.Name("restAPITickerNotification")
    static let webSocketTransactionsNotification = Notification.Name("transactionsNotification")
    static let coinDetailNotificaion = Notification.Name("coinDetailNotificaion")
    static let candleChartDataNotification = Notification.Name("candleChartDataNotification")
    static let moveScrollToMiddleNotification = Notification.Name("moveScrollToMiddleNotification")
}
