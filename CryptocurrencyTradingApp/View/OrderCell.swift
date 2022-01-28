//
//  OrderCell.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/28.
//

import UIKit
import SnapKit

class OrderCell: UITableViewCell {
    private var viewModel: OrderViewModel?
    private var priceLabel = UILabel.makeLabel(font: .subheadline)
    private var ratio: Double = .zero
    private var ratioBar = UIView()
    private var quantityLabel = UILabel.makeLabel(font: .caption1, color: .systemGray)
    private lazy var quantityStackView = UIStackView.makeStackView(alignment: .leading,
                                                                   axis: .vertical,
                                                                   spacing: 3,
                                                                   subviews: [ratioBar, quantityLabel])
    private lazy var cellStackView = UIStackView.makeStackView(alignment: .center,
                                                               subviews: [priceLabel, quantityStackView])
    
    func configure(_ viewModel: OrderViewModel) {
        self.viewModel = viewModel
        configureData(viewModel)
        layoutStackView()
        layoutViews()
    }
    
    private func layoutStackView() {
        addSubview(cellStackView)
        cellStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(7)
            make.bottom.equalToSuperview().offset(-7)
        }
    }
    
    private func layoutViews() {
        priceLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
        priceLabel.textAlignment = .center
        
        ratioBar.snp.makeConstraints { make in
            make.height.equalTo(quantityLabel)
            make.width.equalToSuperview().multipliedBy(ratio)
        }
        let color: UIColor = (viewModel?.orderType == "ask" ? .systemBlue.withAlphaComponent(0.7) : .systemRed.withAlphaComponent(0.7))
        
        ratioBar.backgroundColor = color
        ratioBar.layer.cornerRadius = 1
        priceLabel.textColor = color
        priceLabel.font = .boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .caption1).pointSize)
        
        quantityStackView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    private func configureData(_ viewModel: OrderViewModel) {
        priceLabel.text = viewModel.price
        quantityLabel.text = viewModel.quantity
        ratio = viewModel.ratio
    }
}
