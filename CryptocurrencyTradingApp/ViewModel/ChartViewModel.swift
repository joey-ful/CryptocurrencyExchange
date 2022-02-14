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
    private let market: UpbitMarket
    private let restAPIManager = NetworkManager(networkable: NetworkModule())
    private var divider: Double = .one
    private var visibleXValue = 30
    
    var candleDataSet = CandleChartDataSet()
    var lineDataSet = LineChartDataSet()
    var barDataSet = BarChartDataSet()
    var minimumDate: Double = .zero
    var maximumDate: Double = .zero
    var minimumTimeInterval: Double = .zero
    var multiplier: Double = .one
    var visibleYValue: Double = .one
    var medianY: Double = .one
    var hasRisenList: [Bool] = []
    var scaleY: Double {
        return (candleDataSet.yMax - 0) / (visibleYValue * 1.5)
    }
    var scaleX: Double {
        return Double(candleDataSet.count / visibleXValue)
    }
    
    init(market: UpbitMarket, chartIntervals: ChartInterval) {
        self.market = market
        initiateViewModel(chartIntervals: chartIntervals)
    }

    func initiateViewModel(chartIntervals: ChartInterval) {
        restAPIManager.request(with: UpbitRoute.candles(chartIntervals), queryItems: [.init(name: "market", value: "KRW-ETH"), .init(name: "count", value: "200")], header: nil, bodyParameters: nil, httpMethod: .get, requestType: .requestWithQueryItems) { [weak self] (pasedResult: Result<[UpbitCandleStick], Error>) in
            switch pasedResult {
            case .success(let data):
                self?.multiplier = chartIntervals.multiplier
                self?.prepareCandleData(data)
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    private func prepareCandleData(_ candleData: [UpbitCandleStick]) {
        let candleQueue = DispatchQueue(label: "queue", attributes: .concurrent)
        let lineQueue = DispatchQueue(label: "queue", attributes: .concurrent)
        let barQueue = DispatchQueue(label: "queue", attributes: .concurrent)
        let group = DispatchGroup()
        let min = candleData.map { $0.timestamp }.min() ?? .zero
        let minDate = min.convertDate()
        let max = candleData.map { $0.timestamp }.max() ?? .zero
        let maxDate = max.convertDate()
        let maxOpenPrice = (candleData.map{ $0.openingPrice }.max() ?? 1)
        let minClosePrice = (candleData.map{ $0.closingPrice }.min() ?? 0)
        
        minimumTimeInterval = min.convertDate()
        minimumDate = (minDate - minimumTimeInterval) / multiplier
        maximumDate = (maxDate - minimumTimeInterval) / multiplier
        visibleYValue =  maxOpenPrice - minClosePrice
        medianY = (maxOpenPrice + minClosePrice) / 2

        candleQueue.async(group: group) { [weak self] in
            let chartData: [CandleChartDataEntry] = candleData.reversed().enumerated().map { index, data in
                let date = data.timestamp.convertDate()
                let open = data.openingPrice
                let close = data.closingPrice
                let high = data.highPrice
                let low = data.lowPrice
                self?.hasRisenList.append(open < close)
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
            let lineData: [ChartDataEntry] = candleData.reversed().enumerated().map { index, data in
                let date = data.timestamp.convertDate()
                let high = data.highPrice
                let low = data.lowPrice
                let divided = (date - (self?.minimumTimeInterval ?? 0)) / (self?.multiplier ?? 1)
                return ChartDataEntry(x: divided, y: (low + high) / 2)
            }
            self?.lineDataSet = LineChartDataSet(entries: lineData)
        }

        barQueue.async(group: group) { [weak self] in
            guard let maximumTradeVolume = candleData.compactMap({ $0.tradeVolume }).max(), let minimumPrice = candleData.compactMap({ $0.lowPrice}).min() else { return }
            self?.divider = maximumTradeVolume / minimumPrice
            let barData: [BarChartDataEntry] = candleData.reversed().enumerated().map { index, data in
                let date = data.timestamp.convertDate()
                let tradeVolume = round(data.tradeVolume) / (self?.divider ?? 1)
                let divided = (date - (self?.minimumTimeInterval ?? 0)) / (self?.multiplier ?? 1)
                return BarChartDataEntry(x: divided, y: tradeVolume)
            }
            self?.barDataSet = BarChartDataSet(entries: barData)
        }

        group.notify(queue: DispatchQueue.main) {
            NotificationCenter.default.post(name: .candleChartDataNotification, object: nil)
        }
    }
}
