//
//  detailViewModel.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/01/25.
//

import UIKit
import SwiftUI

final class ChartViewModel: ObservableObject {
    private let coin: CoinType
    private let restAPIManager = RestAPIManager()
    private var candleCoreDataManager = CandleCoreDataManager()

    @Published var highPriceList: [Double] = []
    @Published var startDate: String = ""
    @Published var endDate: String = ""

    init(coin: CoinType, chartIntervals: RequestChartInterval) {
        self.coin = coin
        initiateViewModel(coin: coin, chartIntervals: chartIntervals)
    }
    
    func initiateViewModel(coin: CoinType, chartIntervals: RequestChartInterval) {
        restAPIManager.fetch(type: .candlestick,
                             paymentCurrency: .KRW,
                             coin: coin,
                             chartIntervals: chartIntervals) { (parsedResult: Result<CandleStick, Error>) in
            switch parsedResult {
            case .success(let parsedData):
                self.candleCoreDataManager.addToCoreData(coin: coin, parsedData.data, entityName: chartIntervals)
                let candleData = self.candleCoreDataManager.read(entityName: chartIntervals, coin: coin)
                self.calculateHighPriceList(candleData, chartIntervals: chartIntervals)
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    private func calculateHighPriceList(_ candleData: [CandleStickCoreDataEntity]?, chartIntervals: RequestChartInterval) {
        guard let candleData = candleData
        else { return }
        let result = candleData.sorted{$0.date < $1.date}.suffix(100)
        
        highPriceList = result.map{$0.highPrice}
        startDate = result.first?.date.toDate() ?? "-"
        endDate = result.last?.date.toDate() ?? "-"
        NotificationCenter.default.post(name: .coinChartDataReceiveNotificaion, object: nil)
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
    
    var priceChange: Double {
        (highPriceList.last ?? 0) - (highPriceList.first ?? 0)
    }
    
    var lineColor: Color {
        priceChange > 0 ? Color.red : Color.blue
    }
    
    var yAxis: Double {
        maxY - minY
    }
}
