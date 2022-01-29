//
//  UIButton+Extension.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/28.
//

import UIKit

extension UIButton {
    static func makeButton(imageSymbol: String) -> UIButton {
        let button = UIButton()
        button.setImage(UIImage(systemName: imageSymbol), for: .normal)
        return button
    }
}
