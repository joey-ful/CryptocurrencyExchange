//
//  VolumeCell.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/28.
//

import UIKit
import SnapKit

class OrderTransactionCell: UITableViewCell {
    private var font: UIFont.TextStyle = .caption1
    private lazy var priceLabel = UILabel.makeLabel(font: font)
    private lazy var quantityLabel = UILabel.makeLabel(font: font)
    private lazy var cellStackView = UIStackView.makeStackView(alignment: .center,
                                                               spacing: 0,
                                                               subviews: [priceLabel, quantityLabel])

    func configure(viewModel: TransactionViewModel) {
        configureLabels(viewModel: viewModel)
        layoutStackView()
        layoutLabels()
    }
    
    private func layoutStackView() {
        addSubview(cellStackView)
        cellStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
    
    private func layoutLabels() {
        priceLabel.textAlignment = .left
        quantityLabel.textAlignment = .right
        priceLabel.snp.makeConstraints { $0.leading.equalToSuperview() }
        quantityLabel.snp.makeConstraints { $0.trailing.equalToSuperview() }
    }
    
    private func configureLabels(viewModel: TransactionViewModel) {
        priceLabel.text = viewModel.price
        quantityLabel.text = viewModel.quantity
        
        let textColor: UIColor = viewModel.type == "bid" ?
            .systemBlue.withAlphaComponent(0.7) :
            .systemRed.withAlphaComponent(0.7)
        priceLabel.textColor = textColor
        quantityLabel.textColor = textColor
    }
}
