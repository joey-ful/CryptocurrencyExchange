//
//  CoinListlTableViewCell.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/19.
//

import UIKit
import SnapKit

class MainListTableViewCell: UITableViewCell {
    private var nameLabel = UILabel.makeLabel(font: .body)
    private var symbolLabel = UILabel.makeLabel(font: .caption1, color: .systemGray)
    private var currentPriceLabel = UILabel.makeLabel(font: .body)
    private var fluctuationRateLabel = UILabel.makeLabel(font: .body)
    private var fluctuationAmountLabel = UILabel.makeLabel(font: .caption1)
    private var tradeValueLabel  = UILabel.makeLabel(font: .body)
    
    private lazy var nameStackView = UIStackView.makeStackView(axis: .vertical, subviews: [nameLabel, symbolLabel])
    private lazy var fluctuationStackView = UIStackView
        .makeStackView(alignment: .trailing, axis: .vertical, subviews: [fluctuationRateLabel, fluctuationAmountLabel])
    private lazy var cellStackView = UIStackView.makeStackView(subviews: [
        nameStackView,
        currentPriceLabel,
        fluctuationStackView,
        tradeValueLabel
    ])
    
    private func layoutStackViews() {
        addSubview(cellStackView)
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        cellStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func configure(_ coin: MainListCoin) {
        layoutStackViews()
        nameLabel.text = coin.symbol
        currentPriceLabel.text = coin.currentPrice
        fluctuationRateLabel.text = coin.fluctuationRate
        fluctuationAmountLabel.text = coin.fluctuationAmount
        tradeValueLabel.text = coin.tradeValue
    }
}
