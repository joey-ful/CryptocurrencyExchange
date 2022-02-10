//
//  AssetStatus.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/29.
//

import Foundation

struct BithumbRestAPIAssetStatus: Decodable {
    let data: [String: AssetStatus]
    
    struct AssetStatus: Decodable {
        let withdrawStatus: Int
        let depositStatus: Int
        
        enum CodingKeys: String, CodingKey {
            case withdrawStatus = "withdrawal_status"
            case depositStatus = "deposit_status"
        }
    }
}
