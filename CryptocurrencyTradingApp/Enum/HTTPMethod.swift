//
//  HTTPMethod.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/17.
//

import Foundation

enum HTTPMethod: String {
    case get
    case post
    
    var type: String {
        return self.rawValue.uppercased()
    }
    
}
