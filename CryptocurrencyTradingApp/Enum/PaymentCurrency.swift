//
//  PaymentCurrency.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/02/11.
//

import Foundation

enum PaymentCurrency: String {
    case KRW
    case BTC
    
    var string: String {
        return self.rawValue
    }
}
