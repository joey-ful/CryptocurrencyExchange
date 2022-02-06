//
//  detailViewModel.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/01/25.
//

import UIKit
import SwiftUI
import Charts

final class ChartViewModel: ObservableObject {
    private let coin: CoinType
    private let restAPIManager = RestAPIManager()
    
    var candleDataSet = CandleChartDataSet()
    
    var minimumDate: Double = .zero
    
    var maximumDate: Double = .zero
    var minimumTimeInterval: Double = .zero

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
                self.prepareCandleData(parsedData.data)
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    private func prepareCandleData(_ candleData: [[CandleStick.CandleStickData]]) {
        
        let min = candleData.map { convert($0[0]) }.min() ?? .zero
        minimumTimeInterval = String(min.description.lose(from: ".").dropLast().dropLast().dropLast()).toDouble()
        minimumDate = (minimumTimeInterval - minimumTimeInterval) / 3600
        let max = candleData.map { convert($0[0]) }.max() ?? .zero
        let maxDate = String(max.description.lose(from: ".").dropLast().dropLast().dropLast()).toDouble()
        maximumDate = (maxDate - minimumTimeInterval) / 3600

        
        let chartData: [CandleChartDataEntry] = candleData.enumerated().map { index, data in
            let converted = String(convert(data[0]).description.lose(from: ".").dropLast().dropLast().dropLast()).toDouble()

            
            let date = convert(data[0])
            let open = convert(data[1])
            let close = convert(data[2])
            let high = convert(data[3])
            let low = convert(data[4])
            
            let divided = (converted - minimumTimeInterval) / (3600)
            return CandleChartDataEntry(x: divided,
                                        shadowH: high,
                                        shadowL: low,
                                        open: open,
                                        close: close)
        }
        
        candleDataSet = CandleChartDataSet(entries: chartData)
        
        NotificationCenter.default.post(name: .candleChartDataNotification, object: nil)
    }
    
    private func convert(_ candleData: CandleStick.CandleStickData) -> Double {
        switch candleData {
        case .string(let result):
            return Double(result) ?? .zero
        case .integer(let date):
            return Double(date)
        }
    }
}
