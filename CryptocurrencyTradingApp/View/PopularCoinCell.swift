//
//  PopularCoinCell.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/30.
//

import UIKit
import SnapKit
import SwiftUI

class PopularCoinCell: UICollectionViewCell {
    private var viewModel: PopularCoinViewModel? = nil
    private var coin: CoinType? = nil
    private var nameLabel = UILabel.makeLabel(font: .headline)
    private var priceLabel = UILabel.makeLabel(font: .caption1, color: .systemGray)
    private var directionIcon = UIImageView()
    private var fluctuationLabel = UILabel.makeLabel(font: .caption1)
    private lazy var fluctuationStackView = UIStackView.makeStackView(alignment: .leading,
                                                                      spacing: 3,
                                                                      subviews: [directionIcon,
                                                                                 fluctuationLabel])
    private lazy var labelStackView = UIStackView.makeStackView(alignment: .leading,
                                                                axis: .vertical,
                                                                spacing: 3,
                                                                subviews: [nameLabel,
                                                                           priceLabel,
                                                                           fluctuationStackView,
                                                                           host.view
                                                                          ])
    private lazy var host: UIHostingController = {
        return UIHostingController(rootView: MiniChart(viewModel: viewModel ?? PopularCoinViewModel(popularCoin: Ticker())))
    }()
    
    func configure(_ viewModel: PopularCoinViewModel, parent: UIViewController) {
        backgroundColor = .white
        self.coin = CoinType.coin(symbol: viewModel.symbol)
        self.viewModel = viewModel
        
        embed(in: parent)
        configureData(viewModel)
        layoutStackView(parent)
        layoutViews(viewModel)
    }
    
    private func embed(in parent: UIViewController) {
        parent.addChild(host)
        host.didMove(toParent: parent)
    }
    
    private func layoutStackView(_ parentViewController: UIViewController) {
        layer.cornerRadius = 10
        addSubview(labelStackView)

        labelStackView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(10)
            make.leading.equalTo(contentView.snp.leading).offset(10)
            make.trailing.equalTo(contentView.snp.trailing).offset(-10)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
        }
        
        host.view.snp.makeConstraints {
            $0.width.equalTo(contentView.snp.width).offset(-20)
            $0.height.equalTo(labelStackView.snp.height).multipliedBy(0.5)
        }
    }
    
    private func layoutViews(_ viewModel: PopularCoinViewModel) {
        [nameLabel, priceLabel, fluctuationLabel].forEach { $0.textAlignment = .left }
        
        directionIcon.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        directionIcon.snp.makeConstraints {
            $0.height.equalTo(UIFont.preferredFont(forTextStyle: .caption1).pointSize).multipliedBy(0.5)
            $0.width.equalTo(UIFont.preferredFont(forTextStyle: .caption1).pointSize).multipliedBy(0.05)
        }
        directionIcon.image = viewModel.sign == "+" ? UIImage(systemName: "arrowtriangle.up.fill")?.withTintColor(.systemRed) : UIImage(systemName: "arrowtriangle.down.fill")?.withTintColor(.systemBlue)
        directionIcon.tintColor = viewModel.sign == "+" ? .systemRed : .systemBlue
        fluctuationStackView.alignment = .center
    }
    
    private func configureData(_ viewModel: PopularCoinViewModel) {
        nameLabel.text = viewModel.symbol
        priceLabel.text = viewModel.price
        fluctuationLabel.text = viewModel.sign + viewModel.fluctuationRate
        fluctuationLabel.textColor = viewModel.sign == "+" ? .systemRed : .systemBlue
    }
}
