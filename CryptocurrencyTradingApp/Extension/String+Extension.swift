//
//  String+Extension.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/19.
//

import Foundation

extension String {
    static let percent = "%"
    static let empty = ""
    static let million = "백만"
    static let zero = "0"
    
    func convertedToDecimal() -> String {
        guard let number = Double(self) as NSNumber? else { return .zero }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        guard let formatted = numberFormatter.string(from: number) else { return .zero }
        
        return formatted
    }
    
    func convertedToMillion() -> String {
        guard let number = Double(self) else { return .zero }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        
        let millionNumber = number / 1000000
        guard let formatted = numberFormatter.string(from: NSNumber(value: millionNumber)) else { return .zero }
        
        return formatted
    }
}
