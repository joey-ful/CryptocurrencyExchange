//
//  detailViewModel.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/01/25.
//

import UIKit
import SwiftUI

class ChartViewModel: ObservableObject {
    private let coin: CoinType
    private let restAPIManager = RestAPIManager()
    private var candleCoreDataManager = CandleCoreDataManager()

    @Published var highPriceList: [Double] = []
    @Published var candleDate = Array<CandleStickCoreDataEntity>()

    init(coin: CoinType, chartIntervals: RequestChartInterval) {
        self.coin = coin
        initiateViewModel(coin: coin, chartIntervals: chartIntervals)
        let fetchRequest = CandleData1M.fetchRequest()
        print(fetchRequest)
    }
    
    func initiateViewModel(coin: CoinType, chartIntervals: RequestChartInterval) {
        restAPIManager.fetch(type: .candlestick,
                             paymentCurrency: .KRW,
                             coin: coin,
                             chartIntervals: chartIntervals) { (parsedResult: Result<CandleStick, Error>) in
            switch parsedResult {
            case .success(let parsedData):
                print("시작")
                self.candleCoreDataManager.addToCoreData(coin: coin, parsedData.data, entityName: chartIntervals)
                print("종료")
                let candleData = self.candleCoreDataManager.read(entityName: chartIntervals, coin: coin)
                print("다읽음")
                self.calculateHighPriceList(candleData, chartIntervals: chartIntervals)
                print("가공완료")
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    private func calculateHighPriceList(_ candleData: [CandleStickCoreDataEntity]?, chartIntervals: RequestChartInterval) {
        guard let candleData = candleData,
        let firstData = candleData.first,
              let lastData = candleData.last
        else { return }
        let result = candleData.sorted{$0.date < $1.date}
        print(candleData.count)
//        highPriceList = result[result.count - 60..<result.count].map { $0.highPrice }
        highPriceList = result.suffix(30).map{$0.highPrice}
        NotificationCenter.default.post(name: .coinChartDataReceiveNotificaion, object: nil)
        self.candleDate = [firstData, lastData]
    }

    var maxY: Double {
        highPriceList.max() ?? 0
    }
    
    var averageY: Double {
        (maxY + minY) / 2
    }
    
    var minY: Double {
        highPriceList.min() ?? 0
    }
    
    var startDate: String {
        if candleDate.count > 0 {
            return candleDate[.zero].date.toDate()
        } else {
            return "0"
        }
    }
    
    var endDate: String {
        if candleDate.count > 0 {
            return candleDate[candleDate.count - 1].date.toDate()
        } else {
            return "0"
        }
    }
    
    var priceChange: Double {
        (highPriceList.last ?? 0) - (highPriceList.first ?? 0)
    }
    
    var lineColor: Color {
        priceChange > 0 ? Color.green : Color.red
    }
    
    var yAxis: Double {
        maxY - minY
    }
}
