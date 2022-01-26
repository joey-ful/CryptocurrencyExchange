//
//  DetailChartServices.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/01/25.
//

import Foundation
import Combine


class DetailChartServices {
    private var restAPIManager = RestAPIManager()
    private var candleCoreDataManager = CandleCoreDataManager()
    var candleData: [CandleData] = []

    init (coin: CoinType) {
        NotificationCenter.default.addObserver(self, selector: #selector(fetchData), name: .candlestickNotification, object: nil)
        restAPIManager.fetch(type: .candlestick, paymentCurrency: .KRW, coin: coin, chartIntervals: .oneMinute)
    }

    @objc func fetchData(notification: Notification) {
        if let result = notification.userInfo?["data"] as? [[CandleStick.CandleStickData]] {
            result.forEach { index in
                candleCoreDataManager.create(date: convert(index[0]), openPrice: convert(index[1]), closePrice: convert(index[2]), highPrice: convert(index[3]), lowPrice: convert(index[4]), tradeVolume: convert(index[5]))
            }
            guard let data = try? candleCoreDataManager.context.fetch(CandleData.fetchRequest()) else {
                return
            }
            candleData = data
            NotificationCenter.default.post(name: .sendCandleDataToViewModelNotification, object: nil,userInfo: ["data": candleData])
        } else {
            assertionFailure("error")
        }
    }
    
    private func convert(_ candleData: CandleStick.CandleStickData) -> Double {
        switch candleData {
        case .string(let result):
            return Double(result) ?? .zero
        case .integer(let date):
            return Double(date)
        }
    }
    
      private func convert(_ candleData: CandleStick.CandleStickData) -> String {
          switch candleData {
          case .string(let result):
              return String(result)
          case .integer(let date):
              return String(date)
          }
      }
}
