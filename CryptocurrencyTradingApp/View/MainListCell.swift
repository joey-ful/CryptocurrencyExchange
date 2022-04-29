//
//  CoinListlTableViewCell.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/19.
//

import UIKit
import SnapKit

class MainListCell: UITableViewCell {
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
    private lazy var numbersView = UIStackView.makeStackView(spacing: 5,
                                                             subviews: [priceStackView,
                                                                        fluctuationStackView,
                                                                        tradeValueLabel])
    
    private lazy var cellStackView = UIStackView.makeStackView(subviews: [nameStackView, numbersView])
}

extension MainListCell {
    
    func configure(_ ticker: Ticker, _ viewModel: MainListCoinsViewModel) {
        configureLabel(ticker, viewModel)
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
            make.trailing.equalToSuperview().offset(-20)
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
    
    private func configureLabel(_ ticker: Ticker, _ viewModel: MainListCoinsViewModel) {
        nameLabel.text = ticker.name
        symbolLabel.text = ticker.symbol.uppercased()  + "/KRW"
        currentPriceLabel.text = ticker.currentPrice.toDecimal()
        fluctuationRateLabel.text = ticker.fluctuationRate.setFractionDigits(to: 2) + .percent
        fluctuationAmountLabel.text = ticker.fluctuationAmount.toDecimal()
        tradeValueLabel.text = ticker.tradeValue.dividedByMillion() + .million

        let textColor: UIColor = ticker.fluctuationRate.contains("-") ? .systemBlue : .systemRed
        currentPriceLabel.textColor = textColor
        fluctuationRateLabel.textColor = textColor
        fluctuationAmountLabel.textColor = textColor
    }
    
    private func layoutLabel() {
        nameLabel.lineBreakMode = .byCharWrapping
        nameLabel.numberOfLines = 0
        
        nameLabel.textAlignment = .left
        currentPriceLabel.textAlignment = .right
        fluctuationRateLabel.textAlignment = .right
        fluctuationAmountLabel.textAlignment = .right
        tradeValueLabel.textAlignment = .right
        
        nameStackView.snp.makeConstraints {
            $0.width.equalTo(cellStackView.snp.width).multipliedBy(0.25)
        }
        fluctuationStackView.snp.makeConstraints {
            $0.width.equalTo(cellStackView.snp.width).multipliedBy(0.2)
        }
        tradeValueLabel.snp.makeConstraints {
            $0.width.equalTo(cellStackView.snp.width).multipliedBy(0.25)
        }
    }
    
    func blink(_ hasRisen: Bool) {
        let color: UIColor = hasRisen ? .systemRed : .systemBlue
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, options: []) { [weak self] in
            guard let self = self else { return }
            self.backgroundColor = color.withAlphaComponent(0.1)
            self.underline.widthAnchor.constraint(equalTo: self.currentPriceLabel.widthAnchor).isActive = true
            self.underline.backgroundColor = color
        } completion: { done in
            self.backgroundColor = .clear
            self.underline.backgroundColor = .clear
        }
    }
}
