//
//  Sort.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/22.
//

import UIKit

enum Sort: String {
    case none = "noSort"
    case up = "sortUp"
    case down = "sortDown"
    
    var image: UIImage? {
        return UIImage(named: self.rawValue)
    }
}
