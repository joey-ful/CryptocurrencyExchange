//
//  UpbitAssetStatus.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/02/15.
//

import Foundation

struct UpbitAssetStatus: Decodable {
    let currency: String
    let walletState: String
    
    enum CodingKeys: String, CodingKey {
        case currency
        case walletState = "wallet_state"
    }
}
