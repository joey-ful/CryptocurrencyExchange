//
//  ChartViewController.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/01/21.
//

import UIKit

class ChartViewController: UIViewController {
    
    private var restAPIManager = RestAPIManager()
    private var candleStickData: [[CandleStick.CandleData]] = []

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
}
