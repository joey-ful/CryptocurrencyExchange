//
//  TransactionsTableViewCell.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/25.
//

import UIKit
import SnapKit

class TransactionsTableViewCell: UITableViewCell {
    private let font: UIFont.TextStyle = .footnote
    private let borderWidth: CGFloat = 0.5
    private lazy var timeLabel = UILabel.makeLabel(font: font)
    private lazy var priceLabel = UILabel.makeLabel(font: font)
    private lazy var quantityLabel = UILabel.makeLabel(font: font)
    private lazy var cellStackView = UIStackView.makeStackView(alignment: .center,
                                                               spacing: 0,
                                                               subviews: [timeLabel,
                                                                          priceLabel,
                                                                          quantityLabel])

    func configure(viewModel: TransactionViewModel) {
        layoutViews()
        configureLabels(viewModel: viewModel)
    }
    
    private func layoutViews() {
        addSubview(cellStackView)
        cellStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
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
        
        [timeLabel, priceLabel, quantityLabel].forEach {
            $0.textAlignment = .center
            $0.layer.borderColor = UIColor.systemGray5.cgColor
            $0.layer.borderWidth = borderWidth
        }
    }
    
    private func configureLabels(viewModel: TransactionViewModel) {
        timeLabel.text = viewModel.time
        priceLabel.text = viewModel.price
        quantityLabel.text = viewModel.quantity
        priceLabel.textColor = viewModel.type == "bid" ? .systemBlue : .systemRed
        quantityLabel.textColor = viewModel.type == "bid" ? .systemBlue : .systemRed
    }
}
