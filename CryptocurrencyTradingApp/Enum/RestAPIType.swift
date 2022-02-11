//
//  BithumbRoute.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/17.
//

import Foundation

enum RestAPIType: String {
    case ticker = "ticker/"
    case tickerAll = "ticker/ALL"
    case orderbook = "orderbook/"
    case orderbookAll = "orderbook/ALL"
    case transactionHistory = "transaction_history/"
    case assetsStatus = "assetsstatus/"
    case assetsStatusAll = "assetsstatus/ALL"
    case candlestick = "candlestick/"

    var baseURL: String {
      return "https://api.bithumb.com/public/"
    }

    func urlString(paymentCurrency: PaymentCurrency, coin: CoinType? = nil, chartIntervals: ChartInterval? = .twentyFourHour) -> String? {
        let path = self.rawValue
    
        if path.contains("ALL") {
            return baseURL + path + "_\(paymentCurrency)"
        } else if path.contains("candlestick") {
            guard let coinSymbol = coin?.symbol, let chartIntervals = chartIntervals else { return nil }
            return baseURL + path + "\(coinSymbol)_\(paymentCurrency)\(chartIntervals.bitThumbPath)"
        } else {
            guard let coinSymbol = coin?.symbol else { return nil }
            return baseURL + path + "\(coinSymbol)_\(paymentCurrency)"
        }
    }
}
