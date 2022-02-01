//
//  TransactionsTableViewHeader.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/26.
//

import UIKit

class TransactionsHeader: UITableViewHeaderFooterView {
    private let font: UIFont.TextStyle = .callout
    private let borderWidth: CGFloat = 0.5
    private lazy var timeLabel = UILabel.makeLabel(font: font)
    private lazy var priceLabel = UILabel.makeLabel(font: font)
    private lazy var fluctuationLabel = UILabel.makeLabel(font: font)
    private lazy var quantityLabel = UILabel.makeLabel(font: font)
    
    private lazy var headerStackView = UIStackView.makeStackView(alignment: .center,
                                                               spacing: 0,
                                                               subviews: [timeLabel,
                                                                          priceLabel,
                                                                          fluctuationLabel,
                                                                          quantityLabel])
    
    func configure(isTimeCell: Bool, symbol: String) {
        isTimeCell ? configureTimeHeaderLabels(symbol) : configureDayHeaderLabels(symbol)
        layoutStackView()
        layoutLabels()
    }
    
    private func layoutStackView() {
        addSubview(headerStackView)
        headerStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func layoutLabels() {
        NSLayoutConstraint.activate([
            timeLabel.heightAnchor.constraint(equalToConstant: UIFont.preferredFont(forTextStyle: font).pointSize + 20),
            timeLabel.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.25),
            priceLabel.heightAnchor.constraint(equalToConstant: UIFont.preferredFont(forTextStyle: font).pointSize + 20),
            priceLabel.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: fluctuationLabel.isHidden ? 0.45 : 0.25),
            fluctuationLabel.heightAnchor.constraint(equalToConstant: UIFont.preferredFont(forTextStyle: font).pointSize + 20),
            quantityLabel.heightAnchor.constraint(equalToConstant: UIFont.preferredFont(forTextStyle: font).pointSize + 20),
            quantityLabel.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.3)
        ])
        
        [timeLabel, priceLabel, fluctuationLabel, quantityLabel].forEach {
            $0.textAlignment = .center
            $0.layer.borderColor = UIColor.systemGray5.cgColor
            $0.layer.borderWidth = borderWidth
        }
    }
    
    private func configureTimeHeaderLabels(_ symbol: String) {
        fluctuationLabel.isHidden = true
        
        timeLabel.text = "시간"
        priceLabel.text = "가격(KRW)"
        quantityLabel.text = "체결량(\(symbol))"
    }
    
    private func configureDayHeaderLabels(_ symbol: String) {
        timeLabel.text = "일자"
        priceLabel.text = "종가(KRW)"
        fluctuationLabel.text = "전일대비"
        quantityLabel.text = "거래량(\(symbol))"
    }
}
