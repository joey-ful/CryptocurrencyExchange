//
//  TransactionsTableViewCell.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/25.
//

import UIKit
import SnapKit

class TransactionsTableViewCell: UITableViewCell {

    private var timeLabel = UILabel.makeLabel(font: .subheadline)
    private var priceLabel = UILabel.makeLabel(font: .subheadline)
    private var quantityLabel = UILabel.makeLabel(font: .subheadline)
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
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    private func configureLabels(viewModel: TransactionViewModel) {
        timeLabel.text = viewModel.time
        priceLabel.text = viewModel.price
        quantityLabel.text = viewModel.quantity
    }
}
