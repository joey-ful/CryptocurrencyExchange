//
//  PopularCoinCell.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/30.
//

import UIKit
import SnapKit
import SwiftUI

struct MiniChartView: View {
    var body: some View {
        Text("chart")
    }
}

class PopularCoinCell: UICollectionViewCell {
    private var coin: CoinType?
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
        return UIHostingController(rootView: MiniChartView())
    }()
    
    func configure(_ viewModel: PopularCoinViewModel, parentViewController: UIViewController) {
        backgroundColor = .white
        self.coin = CoinType.coin(symbol: viewModel.symbol)
        
        embed(in: parentViewController)
        configureData(viewModel)
        layoutStackView(parentViewController)
        layoutViews(viewModel)
    }
    
    private func embed(in parent: UIViewController) {
        parent.addChild(host)
        host.didMove(toParent: parent)
    }
    
    private func layoutStackView(_ parentViewController: UIViewController) {
        layer.cornerRadius = 10
        addSubview(labelStackView)
        host.view.backgroundColor = .systemPink

        labelStackView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(10)
            make.leading.equalTo(contentView.snp.leading).offset(10)
            make.trailing.equalTo(contentView.snp.trailing).offset(-10)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
        }
    }
    
    private func layoutViews(_ viewModel: PopularCoinViewModel) {
        [nameLabel, priceLabel, fluctuationLabel].forEach { $0.textAlignment = .left }
        
        directionIcon.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        directionIcon.snp.makeConstraints {
            $0.height.equalTo(fluctuationLabel.snp.height).multipliedBy(0.8)
            $0.width.equalTo(directionIcon.snp.height).multipliedBy(0.8)
        }
        directionIcon.image = viewModel.sign == "+" ? UIImage(systemName: "arrowtriangle.up.fill")?.withTintColor(.systemRed) : UIImage(systemName: "arrowtriangle.down.fill")?.withTintColor(.systemBlue)
        directionIcon.tintColor = viewModel.sign == "+" ? .systemRed : .systemBlue
    }
    
    private func configureData(_ viewModel: PopularCoinViewModel) {
        nameLabel.text = viewModel.symbol
        priceLabel.text = viewModel.price
        fluctuationLabel.text = viewModel.sign + viewModel.fluctuationRate
        fluctuationLabel.textColor = viewModel.sign == "+" ? .systemRed : .systemBlue
    }
}
