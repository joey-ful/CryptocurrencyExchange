//
//  Notification.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/01/17.
//

import Foundation

extension Notification.Name {
    static let restAPITickerAllNotification = Notification.Name("restAPITickerAllNotification")
    static let restAPITickerNotification = Notification.Name("restAPITickerNotification")
    static let candlestickNotification = Notification.Name("candlestickNotification")
    static let restAPITransactionsNotification = Notification.Name("transactionsNotification")
    static let assetStatusNotification = Notification.Name("assetStatusNotification")
    static let restAPIOrderNotification = Notification.Name("restAPIOrderNotification")
 
    static let webSocketTransactionsNotification = Notification.Name("transactionsNotification")
    static let webSocketTicker24HNotification = Notification.Name("webSocketTicker24HNotification")
    static let webSocketTickerNotification = Notification.Name("webSocketTickerNotification")
    static let webSocketOrderbookNotification = Notification.Name("webSocketOrderbookNotification")
    static let coinDetailNotificaion = Notification.Name("coinDetailNotificaion")
    static let coinChartDataReceiveNotificaion = Notification.Name("coinChartDataReceiveNotificaion")
    static let coinChartWebSocketReceiveNotificaion = Notification.Name("coinChartWebSocketReceiveNotificaion")
    
    static let updateSortIconsNotification = Notification.Name("updateSortIconsNotification")
}
