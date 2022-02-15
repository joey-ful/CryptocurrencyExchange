//
//  Data+Extension.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/02/15.
//

import Foundation

extension Data {
    func urlSafeBase64EncodedString() -> String {
        return base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}
