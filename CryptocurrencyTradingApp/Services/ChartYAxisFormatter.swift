//
//  ChartYAxisFormatter.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/02/07.
//

import Foundation
import Charts

class ChartYAxisFormatter: NSObject { }

extension ChartYAxisFormatter: AxisValueFormatter {

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return value.description.toDecimal().lose(from: ".")
    }

}
