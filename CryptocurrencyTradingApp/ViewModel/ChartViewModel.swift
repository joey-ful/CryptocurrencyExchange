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
    var lineDataSet = LineChartDataSet()
    
    var minimumDate: Double = .zero
    var maximumDate: Double = .zero
    var minimumTimeInterval: Double = .zero
    
    var multiplier: Double = .one
    var visibleXValue = 30
    var scaleX: Double {
        return Double(candleDataSet.count / visibleXValue)
    }
    var visibleYValue: Double = .one
    var scaleY: Double {
        return (candleDataSet.yMax - candleDataSet.yMin) / visibleYValue
    }
    var medianY: Double = .one
    
    init(coin: CoinType, chartIntervals: RequestChartInterval) {
        self.coin = coin
        initiateViewModel(chartIntervals: chartIntervals)
    }
    
    func initiateViewModel(chartIntervals: RequestChartInterval) {
        restAPIManager.fetch(type: .candlestick,
                             paymentCurrency: .KRW,
                             coin: coin,
                             chartIntervals: chartIntervals) { [weak self] (parsedResult: Result<CandleStick, Error>) in
            switch parsedResult {
            case .success(let parsedData):
                self?.multiplier = chartIntervals.multiplier
                self?.prepareCandleData(parsedData.data)
            case .failure(NetworkError.unverifiedCoin):
                print(NetworkError.unverifiedCoin.localizedDescription)
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    private func prepareCandleData(_ candleData: [[CandleStick.CandleStickData]]) {
        let candleQueue = DispatchQueue(label: "queue", attributes: .concurrent)
        let lineQueue = DispatchQueue(label: "queue", attributes: .concurrent)
        let group = DispatchGroup()
        let min = candleData.map { convert($0[0]) }.min() ?? .zero
        minimumTimeInterval = String(min.description.lose(from: ".").dropLast().dropLast().dropLast()).toDouble()
        minimumDate = (minimumTimeInterval - minimumTimeInterval) / multiplier
        let max = candleData.map { convert($0[0]) }.max() ?? .zero
        let maxDate = String(max.description.lose(from: ".").dropLast().dropLast().dropLast()).toDouble()
        maximumDate = (maxDate - minimumTimeInterval) / multiplier

        let maxOpenPrice = (candleData.suffix(30).map{ convert($0[1]) }.max() ?? 1)
        let minClosePrice = (candleData.suffix(30).map{ convert($0[2]) }.min() ?? 0)
        visibleYValue =  maxOpenPrice - minClosePrice
        medianY = (maxOpenPrice + minClosePrice) / 2
        
        candleQueue.async(group: group) { [weak self] in
            let chartData: [CandleChartDataEntry] = candleData.enumerated().map { index, data in
                let rawDate = self?.convert(data[0]) ?? 0
                let date = String(rawDate.description.lose(from: ".").dropLast().dropLast().dropLast()).toDouble()
                let open = self?.convert(data[1]) ?? 0
                let close = self?.convert(data[2]) ?? 0
                let high = self?.convert(data[3]) ?? 0
                let low = self?.convert(data[4]) ?? 0
                
                let divided = (date - (self?.minimumTimeInterval ?? 0)) / (self?.multiplier ?? 1)
                return CandleChartDataEntry(x: divided,
                                            shadowH: high,
                                            shadowL: low,
                                            open: open,
                                            close: close)
            }
            
            self?.candleDataSet = CandleChartDataSet(entries: chartData)
        }
        
        lineQueue.async(group: group) { [weak self] in
            let lineData: [ChartDataEntry] = candleData.enumerated().map { index, data in
                let rawDate = self?.convert(data[0]) ?? 0
                let date = String(rawDate.description.lose(from: ".").dropLast().dropLast().dropLast()).toDouble()
                let high = self?.convert(data[3]) ?? 0
                let low = self?.convert(data[4]) ?? 0
                
                let divided = (date - (self?.minimumTimeInterval ?? 0)) / (self?.multiplier ?? 1)
                return ChartDataEntry(x: divided, y: (high + low) / 2)
            }
            self?.lineDataSet = LineChartDataSet(entries: lineData)
        }
        
        group.notify(queue: DispatchQueue.main) {
            NotificationCenter.default.post(name: .candleChartDataNotification, object: nil)
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
}
