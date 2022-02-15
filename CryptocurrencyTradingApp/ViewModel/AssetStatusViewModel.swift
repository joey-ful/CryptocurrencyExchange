//
//  AssetStatusViewModel.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/29.
//

import Foundation

class AssetStatusViewModel {
    let data: AssetStatus
    
    init(data: AssetStatus) {
        self.data = data
    }
    
    var coinName: String {
        return data.coinName
    }
        
    var symbol: String {
        return data.symbol
    }
    
    var withdrawStatus: Bool {
        return data.withdraw
    }
    
    var depositStatus: Bool {
        return data.deposit
    }
}
