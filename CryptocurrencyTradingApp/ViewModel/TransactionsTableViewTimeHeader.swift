//
//  TransactionsTableViewHeader.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/26.
//

import UIKit

class TransactionsTableViewTimeHeader: UITableViewHeaderFooterView {
    private let font: UIFont.TextStyle = .callout
    private let borderWidth: CGFloat = 0.5
    private lazy var timeLabel = UILabel.makeLabel(font: font, text: "시간")
    private lazy var priceLabel = UILabel.makeLabel(font: font, text: "가격(KRW)")
    private lazy var quantityLabel = UILabel.makeLabel(font: font, text: "체결량(BTC)")
    
    private lazy var headerStackView = UIStackView.makeStackView(subviews: [
        timeLabel,
        priceLabel,
        quantityLabel,
    ])
    
    func configure() {
        addSubview(headerStackView)
        headerStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        
        
        NSLayoutConstraint.activate([
            timeLabel.heightAnchor.constraint(equalToConstant: UIFont.preferredFont(forTextStyle: font).pointSize + 20),
            timeLabel.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.25),
            priceLabel.heightAnchor.constraint(equalToConstant: UIFont.preferredFont(forTextStyle: font).pointSize + 20),
            quantityLabel.heightAnchor.constraint(equalToConstant: UIFont.preferredFont(forTextStyle: font).pointSize + 20),
            quantityLabel.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.35)
        ])
        
        timeLabel.textAlignment = .center
        timeLabel.layer.borderColor = UIColor.systemGray5.cgColor
        timeLabel.layer.borderWidth = borderWidth
        priceLabel.textAlignment = .center
        priceLabel.layer.borderColor = UIColor.systemGray5.cgColor
        priceLabel.layer.borderWidth = borderWidth
        quantityLabel.textAlignment = .center
        quantityLabel.layer.borderColor = UIColor.systemGray5.cgColor
        quantityLabel.layer.borderWidth = borderWidth
    }
}
