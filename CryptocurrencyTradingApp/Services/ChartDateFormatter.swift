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

    convenience init(referenceTimeInterval: TimeInterval) {
        self.init()
        self.referenceTimeInterval = referenceTimeInterval
    }
}

extension ChartXAxisFormatter: AxisValueFormatter {

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard let reference = referenceTimeInterval else { return .zero }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateFormat = "yy-MM-dd"
        
        let date = Date(timeIntervalSince1970: value * 3600 + reference)
        return formatter.string(from: date)
    }

}
