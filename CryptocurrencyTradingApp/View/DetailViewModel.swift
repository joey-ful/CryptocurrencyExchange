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
    private var service: DetailChartServices

    @Published var highPriceList: [Double] = []
    @Published var candleData: [CandleData] = []
    
    init(coin: CoinType) {
        self.coin = coin
        service = DetailChartServices(coin: coin)
        NotificationCenter.default.addObserver(self, selector: #selector(fetchDataToViewModel), name: .sendCandleDataToViewModelNotification, object: nil)
    }
    
    @objc func fetchDataToViewModel(notification: Notification) {
        guard let data = notification.userInfo?["data"] as? [CandleData], let firstData = data.first, let lastData = data.last else {
            return }
        
        candleData = [firstData, lastData]
        highPriceList = data[data.count - 60..<data.count].map { $0.highPrice}
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
