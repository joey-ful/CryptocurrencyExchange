//
//  UILable+Extension.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/19.
//

import UIKit

extension UILabel {
    static func makeLabel(font: UIFont.TextStyle = .body, text: String = "-", color: UIColor = .black) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = color
        label.font = UIFont.preferredFont(forTextStyle: font)
        label.text = text
        return label
    }
}
