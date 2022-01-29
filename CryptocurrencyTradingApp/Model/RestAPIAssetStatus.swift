//
//  AssetStatus.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/29.
//

import Foundation

struct RestAPIAssetStatus: Decodable {
    let data: Data
    
    struct Data: Decodable {
        let withdrawStatus: Int
        let depositStatus: Int
    }
}
