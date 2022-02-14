//
//  Double+Extension.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/29.
//

import Foundation

extension Double {
    static let million = Double(1000000)
    static let tenMillion = Double(100000000)
    static let one = Double(1)
    static let oneHundred = Double(100)
    
    func convertDate() -> Double {
        let data = self.description.components(separatedBy: ".")[0]
        let start = data.startIndex
        let end = data.index(data.endIndex, offsetBy: -3)
        return Double(data[start..<end]) ?? 0
    }
}
