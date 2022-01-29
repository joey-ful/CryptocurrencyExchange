//
//  StatusCell.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/29.
//

import UIKit
import SnapKit

class StatusCell: UITableViewCell {
    private var font: UIFont.TextStyle = .footnote
    private lazy var coinNameLabel = UILabel.makeLabel(font: .subheadline)
    private lazy var symbolLabel = UILabel.makeLabel(font: .caption1, color: .systemGray)
    private lazy var nameStackView = UIStackView.makeStackView(alignment: .leading,
                                                               axis: .vertical,
                                                               spacing: 3,
                                                               subviews: [coinNameLabel,
                                                                          symbolLabel])
    private lazy var withdrawStatusLabel = UILabel.makeLabel(font: .subheadline)
    private lazy var depositStatusLabel = UILabel.makeLabel(font: .subheadline)
    private lazy var cellStackView = UIStackView.makeStackView(alignment: .center,
                                                               subviews: [nameStackView,
                                                                          withdrawStatusLabel,
                                                                          depositStatusLabel])

    func configure(viewModel: AssetStatusViewModel) {
        configureLabels(viewModel: viewModel)
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
        nameStackView.snp.makeConstraints { $0.width.equalToSuperview().multipliedBy(5) }
        withdrawStatusLabel.snp.makeConstraints { $0.width.equalToSuperview().multipliedBy(0.25) }
        depositStatusLabel.snp.makeConstraints { $0.width.equalToSuperview().multipliedBy(0.25) }
        coinNameLabel.textAlignment = .left
        symbolLabel.textAlignment = .left
        withdrawStatusLabel.textAlignment = .right
        depositStatusLabel.textAlignment = .right
    }
    
    private func configureLabels(viewModel: AssetStatusViewModel) {
        coinNameLabel.text = viewModel.coinName
        symbolLabel.text = viewModel.symbol
        withdrawStatusLabel.text = viewModel.withdrawStatus == 1 ? "가능" : "불가"
        withdrawStatusLabel.textColor = viewModel.withdrawStatus == 1 ? .black : .systemGray
        depositStatusLabel.text = viewModel.depositStatus == 1 ? "가능" : "불가"
        depositStatusLabel.textColor = viewModel.depositStatus == 1 ? .black : .systemGray
    }
}
