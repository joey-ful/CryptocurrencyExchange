//
//  TransactionTableViewTimeCell.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/27.
//

import UIKit
import SnapKit

class TransactionsCell: UITableViewCell {
    private var font: UIFont.TextStyle = .footnote
    private let borderWidth: CGFloat = 0.5
    private lazy var timeLabel = UILabel.makeLabel(font: font)
    private lazy var priceLabel = UILabel.makeLabel(font: font)
    private lazy var fluctuationLabel = UILabel.makeLabel(font: font)
    private lazy var quantityLabel = UILabel.makeLabel(font: font)
    private lazy var cellStackView = UIStackView.makeStackView(alignment: .center,
                                                               spacing: 0,
                                                               subviews: [timeLabel,
                                                                          priceLabel,
                                                                          fluctuationLabel,
                                                                          quantityLabel])

    func configure(isTimeCell: Bool, viewModel: TransactionViewModelType) {
        isTimeCell ? configureTimeLabels(viewModel: viewModel as? TransactionViewModel) : configureDayLabels(viewModel: viewModel as? DayTransactionViewModel)
        layoutStackView()
        layoutLabels()
    }
    
    private func layoutStackView() {
        addSubview(cellStackView)
        cellStackView.snp.makeConstraints { make in
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
    
    private func configureTimeLabels(viewModel: TransactionViewModel?) {
        fluctuationLabel.isHidden = true
        
        timeLabel.text = viewModel?.time
        priceLabel.text = viewModel?.price
        quantityLabel.text = viewModel?.quantity
        
        let textColor: UIColor = viewModel?.type == "bid" ? .systemBlue : .systemRed
        priceLabel.textColor = textColor
        quantityLabel.textColor = textColor
    }
    
    private func configureDayLabels(viewModel: DayTransactionViewModel?) {
        timeLabel.text = viewModel?.date
        priceLabel.text = viewModel?.closePrice
        fluctuationLabel.text = viewModel?.fluctuationRate
        quantityLabel.text = viewModel?.quantity
        
        let textColor: UIColor = (viewModel?.fluctuationRate ?? "-").contains("-") ? .systemBlue : .systemRed
        priceLabel.textColor = textColor
        fluctuationLabel.textColor = textColor
    }
}
