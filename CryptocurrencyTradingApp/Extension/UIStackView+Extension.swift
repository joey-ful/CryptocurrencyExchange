//
//  UIStackView+Extension.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/19.
//

import UIKit

extension UIStackView {
    static func makeStackView(alignment: UIStackView.Alignment = .fill,
                              distribution: UIStackView.Distribution = .fill,
                              axis: NSLayoutConstraint.Axis = .horizontal,
                              spacing: CGFloat = 0,
                              subviews: [UIView] = [])
    -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: subviews)
        stackView.alignment = alignment
        stackView.distribution = distribution
        stackView.axis = axis
        stackView.spacing = spacing
        return stackView
    }
}
