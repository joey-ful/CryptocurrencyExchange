//
//  ChartViewController.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/01/21.
//

import UIKit
import SnapKit
import Charts

class ChartViewController: UIViewController {
    
    private var chartView: CombinedChartView!

    
    private var restAPIManager = RestAPIManager()
    private var candleStickData: [[CandleStick.CandleData]] = []
    private var data: CombinedChartData = CombinedChartData()

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(fetchData), name: .candlestickNotification, object: nil)
        restAPIManager.fetch(type: .candlestick, paymentCurrency: .KRW, coin: .ada, chartIntervals: .oneMinute)
    }
    
    
    @objc func fetchData(notification: Notification) {
        if let result = notification.userInfo?["data"] as? [[CandleStick.CandleData]] {
            candleStickData = result
        } else {
            print("error")
        }
    }
    
    private func convert(_ candleData: CandleStick.CandleData) -> Double {
        switch candleData {
        case .string(let result):
            return Double(result) ?? .zero
        case .integer(let date):
            return Double(date)
        }
    }
    
    private func makeLineChartData() -> LineChartDataSet {
        let lineChartDataEntires = (.zero..<candleStickData.count - 1).map {(i) -> ChartDataEntry in
            let data = convert(candleStickData[i][3])
            let highValue = convert(candleStickData[i][2])
            let date = convert(candleStickData[i][.zero])
            return ChartDataEntry(x: date, y: highValue)
        }
        return LineChartDataSet(entries: lineChartDataEntires, label: "LineChart")
    }
    
    private func makeCandleChartData() -> CandleChartDataSet {
        let dataEntries1 = (.zero...candleStickData.count).map {(i) -> CandleChartDataEntry in
            let val = Double(arc4random_uniform(40) + 10)
            let high = Double(arc4random_uniform(9) + 8)
            let low = Double(arc4random_uniform(9) + 8)
            let open = Double(arc4random_uniform(6) + 1)
            let close = Double(arc4random_uniform(6) + 1)
            let even = arc4random_uniform(2) % 2 == 0
            
            return CandleChartDataEntry(x: Double(i), shadowH: val + high, shadowL: val-low, open: even ? val + open: val-open, close: even ? val-close: val + close)
        }
        return CandleChartDataSet(entries: dataEntries1, label: "candleChart")
    }
}
