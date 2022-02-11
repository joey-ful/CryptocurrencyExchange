//
//  HTTPMethod.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/02/11.
//

import Foundation

enum HTTPMethod: String {
    case get
    case put
    case petch
    case delete
    case post
    
    var type: String {
        return self.rawValue.uppercased()
    }
    
}
