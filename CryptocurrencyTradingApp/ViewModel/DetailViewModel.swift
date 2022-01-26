//
//  detailViewModel.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/01/25.
//

import UIKit
import SwiftUI

class DetailViewModel: ObservableObject {
    private let coin: CoinType
    private let restAPIManager = RestAPIManager()
    private var candleCoreDataManager = CandleCoreDataManager()

    @Published var highPriceList: [Double] = []
    @Published var candleData: [CandleData] = []
    
    init(coin: CoinType) {
        self.coin = coin
        restAPIManager.fetch(type: .candlestick,
                             paymentCurrency: .KRW,
                             coin: coin,
                             chartIntervals: .oneMinute) { (parsedResult: Result<CandleStick, Error>) in
            switch parsedResult {
            case .success(let parsedData):
                self.candleCoreDataManager.addToCoreData(parsedData.data)
                let candleData = self.candleCoreDataManager.read()
                self.calculateHighPriceList(candleData)
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    private func calculateHighPriceList(_ candleData: [CandleData]?) {
        guard let candleData = candleData,
        let firstData = candleData.first,
            let lastData = candleData.last else { return }
        
        self.candleData = [firstData, lastData]
        highPriceList = candleData[candleData.count - 60..<candleData.count].map { $0.highPrice}
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
        if candleData.count > 0 {
            return candleData[.zero].date.toDate()
        } else {
            return "0"
        }
    }
    
    var endDate: String {
        if candleData.count > 0 {
            return candleData[candleData.count - 1].date.toDate()
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
