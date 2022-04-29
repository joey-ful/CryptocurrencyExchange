//
//  UpdatedInfo.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/04/29.
//

import Foundation

struct UpdatedInfo {
    let index: Int
    let hasRisen: Bool
}

extension UpdatedInfo {
    init() {
        index = .zero
        hasRisen = false
    }
}
