//
//  RequestType.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/01/17.
//

import Foundation

enum RequestType: String {
    case ticker
    case transaction
    case orderbookdepth
    
    var name: String {
        return self.rawValue
    }
}
