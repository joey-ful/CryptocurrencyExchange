//
//  AssetStatus.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/29.
//

import Foundation

struct AssetStatus: Hashable {
    let coinName: String
    let symbol: String
    let withdraw: Int
    let deposit: Int
}
