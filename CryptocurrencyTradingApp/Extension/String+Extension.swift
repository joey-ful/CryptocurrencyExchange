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
    static let tenMillion = "억"
    static let whiteSpace = " "
    
    /// 3자리마다 comma
    func toDecimal() -> String {
        guard let number = Double(self) as NSNumber? else { return .zero }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        guard let formatted = numberFormatter.string(from: number) else { return .zero }
        
        return formatted
    }
    
    /// 3자리마다 comma + 소수점 버리기 + 백만으로 나누기
    func dividedByMillion() -> String {
        guard let number = Double(self) else { return .zero }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = .zero
        
        let numberOverMillion = number / .million
        guard let formatted = numberFormatter.string(from: NSNumber(value: numberOverMillion)) else { return .zero }
        
        return formatted
    }
    
    /// 3자리마다 comma + 소수점 버리기 + 1억으로 나누기
    func dividedByHundredMillion() -> String {
        guard let number = Double(self) else { return .zero }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = .zero
        
        let numberOverTenMillion = number / .tenMillion
        guard let formatted = numberFormatter.string(from: NSNumber(value: numberOverTenMillion)) else { return .zero }
        
        return formatted
    }
    
    /// 숫자, - 기호, . 기호를 제외한 문자열을 Double로 변환
    func toDouble() -> Double {
        let number = self.filter { $0.isNumber || $0 == "-" || $0 == "." }
        return Double(number) ?? .zero
    }
    
    func toDate() -> String {
        let text = self.lose(from: ".")
        let start = text.startIndex
        let end = text.index(text.endIndex, offsetBy: -3)
        let data = Double(text[start..<end]) ?? .zero
        
        func convert(data: Double) -> String{
            let date = Date(timeIntervalSince1970: data)
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_kr")
            formatter.timeZone = TimeZone(abbreviation: "KST")
            formatter.dateFormat = "HH:mm:ss"
            
            return formatter.string(from: date)
        }
        return convert(data: data)
    }
    
    func toTime() -> String {
        let text = self.lose(from: ".")
        let start = text.startIndex
        let end = text.index(text.endIndex, offsetBy: -3)
        let data = Double(text[start..<end]) ?? .zero
        
        func convert(data: Double) -> String{
            let date = Date(timeIntervalSince1970: data)
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_kr")
            formatter.timeZone = TimeZone(abbreviation: "KST")
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            
            return formatter.string(from: date)
        }
        return convert(data: data)
    }

    /// separator 이후의 모든 것을 제거한 문자열을 반환
    func lose(from separator: String.Element) -> String {
        return String(self.split(separator: separator)[0])
    }
    
    /// 지정한 개수만큼의 소수점 아래 자리를 고정
    func setFractionDigits(to count: Int) -> String {
        guard let number = Double(self) as NSNumber? else { return .zero }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = count
        numberFormatter.minimumFractionDigits = count
        
        guard let formatted = numberFormatter.string(from: number) else { return .zero }
        
        return formatted
    }
}
