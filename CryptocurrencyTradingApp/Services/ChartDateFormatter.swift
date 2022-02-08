//
//  ChartDateFormatter.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/02/06.
//

import Foundation
import Charts

class ChartXAxisFormatter: NSObject {
    private var referenceTimeInterval: TimeInterval?
    private var multiplier: Double = 1

    convenience init(referenceTimeInterval: TimeInterval, multiplier: Double) {
        self.init()
        self.referenceTimeInterval = referenceTimeInterval
        self.multiplier = multiplier
    }
}

extension ChartXAxisFormatter: AxisValueFormatter {

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard let reference = referenceTimeInterval else { return .zero }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateFormat = "yy-MM-dd HH:mm"
        
        let date = Date(timeIntervalSince1970: value * multiplier + reference)
        return formatter.string(from: date)
    }

}
