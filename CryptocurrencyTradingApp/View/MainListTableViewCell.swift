//
//  CoinListlTableViewCell.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/19.
//

import UIKit
import SnapKit

class MainListTableViewCell: UITableViewCell {
    private var nameLabel = UILabel.makeLabel(font: .subheadline)
    private var symbolLabel = UILabel.makeLabel(font: .caption1, color: .systemGray)
    private var currentPriceLabel = UILabel.makeLabel(font: .subheadline)
    private var fluctuationRateLabel = UILabel.makeLabel(font: .subheadline)
    private var fluctuationAmountLabel = UILabel.makeLabel(font: .caption1)
    private var tradeValueLabel  = UILabel.makeLabel(font: .subheadline)
    private lazy var underline: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 2).isActive = true
        return view
    }()
    
    private lazy var nameStackView = UIStackView.makeStackView(axis: .vertical,
                                                               subviews: [nameLabel, symbolLabel])
    private lazy var priceStackView = UIStackView.makeStackView(axis: .vertical,
                                                                subviews: [currentPriceLabel, underline])
    private lazy var fluctuationStackView = UIStackView.makeStackView(alignment: .trailing,
                                                                      axis: .vertical,
                                                                      subviews: [fluctuationRateLabel,
                                                                                 fluctuationAmountLabel])
    private lazy var numbersView = UIStackView.makeStackView(subviews: [priceStackView,
                                                                        fluctuationStackView,
                                                                        tradeValueLabel])
    
    private lazy var cellStackView = UIStackView.makeStackView(subviews: [nameStackView,
                                                                          numbersView])
}

extension MainListTableViewCell {
    
    func configure(_ coin: MainListCoin) {
        configureLabel(coin)
        layoutLabel()
        layoutStackViews()
    }
    
    private func layoutStackViews() {
        nameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        fluctuationRateLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        fluctuationAmountLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        tradeValueLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        nameLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        priceStackView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        tradeValueLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        addSubview(cellStackView)
        cellStackView.translatesAutoresizingMaskIntoConstraints = false
        cellStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        NSLayoutConstraint.activate([
            currentPriceLabel.trailingAnchor.constraint(equalTo: priceStackView.trailingAnchor),
            underline.trailingAnchor.constraint(equalTo: priceStackView.trailingAnchor)
        ])
        
        priceStackView.alignment = .firstBaseline
        cellStackView.alignment = .center
    }
    
    private func configureLabel(_ coin: MainListCoin) {
        nameLabel.text = coin.name
        symbolLabel.text = coin.symbol
        currentPriceLabel.text = coin.currentPrice
        fluctuationRateLabel.text = coin.fluctuationRate
        fluctuationAmountLabel.text = coin.fluctuationAmount
        tradeValueLabel.text = coin.tradeValue
        
        currentPriceLabel.textColor = coin.textColor
        fluctuationRateLabel.textColor = coin.textColor
        fluctuationAmountLabel.textColor = coin.textColor
    }
    
    private func layoutLabel() {
        nameLabel.lineBreakMode = .byCharWrapping
        nameLabel.numberOfLines = 0
        
        nameLabel.textAlignment = .left
        currentPriceLabel.textAlignment = .right
        fluctuationRateLabel.textAlignment = .right
        fluctuationAmountLabel.textAlignment = .right
        tradeValueLabel.textAlignment = .right
        
        NSLayoutConstraint.activate([
            fluctuationStackView.widthAnchor.constraint(equalToConstant: 75),
            tradeValueLabel.widthAnchor.constraint(equalToConstant: 85)
        ])
    }
    
    func blink(in color: UIColor) {
        UIView.animate(withDuration: 0.2, delay: 0, options: []) {
            self.backgroundColor = color.withAlphaComponent(0.1)
            self.underline.widthAnchor.constraint(equalTo: self.currentPriceLabel.widthAnchor).isActive = true
            self.underline.backgroundColor = color
        } completion: { done in
            self.backgroundColor = .clear
            self.underline.backgroundColor = .clear
        }
    }
}
