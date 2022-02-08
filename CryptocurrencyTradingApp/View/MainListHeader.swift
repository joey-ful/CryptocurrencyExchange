//
//  MainListHeaderView.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/22.
//

import UIKit

class MainListHeader: UITableViewHeaderFooterView {
    private var viewModel: MainListHeaderViewModel?
    private let nameLabel = UILabel.makeLabel(font: .caption1, text: "가상자산명", color: .systemGray)
    private let priceLabel = UILabel.makeLabel(font: .caption1, text: "현재가", color: .systemGray)
    private let fluctuationLabel = UILabel.makeLabel(font: .caption1, text: "변동률", color: .systemGray)
    private let tradeValueLabel = UILabel.makeLabel(font: .caption1, text: "거래금액", color: .systemGray)
    
    private var nameSortIcon = UIImageView(image: Sort.none.image)
    private var priceSortIcon = UIImageView(image: Sort.none.image)
    private var fluctuationSortIcon = UIImageView(image: Sort.none.image)
    private var tradeValueSortIcon = UIImageView(image: Sort.down.image)
    
    private lazy var nameStackView = UIStackView.makeStackView(distribution: .fill,
                                                               spacing: 5,
                                                               subviews: [nameLabel, nameSortIcon])
    private lazy var priceStackView = UIStackView.makeStackView(distribution: .fill,
                                                                spacing: 5,
                                                                subviews: [priceLabel, priceSortIcon])
    private lazy var fluctuationStackView = UIStackView.makeStackView(distribution: .fill,
                                                                      spacing: 5,
                                                                      subviews: [fluctuationLabel,
                                                                                 fluctuationSortIcon])
    private lazy var tradeValueStackView = UIStackView.makeStackView(distribution: .fill,
                                                                     spacing: 5,
                                                                     subviews: [tradeValueLabel,
                                                                                tradeValueSortIcon])
    private lazy var headerStackView = UIStackView.makeStackView(subviews: [
        nameStackView,
        priceStackView,
        fluctuationStackView,
        tradeValueStackView
    ])

    private var nameTapGestureRecognizer = UITapGestureRecognizer()
    private var priceTapGestureRecognizer = UITapGestureRecognizer()
    private var fluctuationTapGestureRecognizer = UITapGestureRecognizer()
    private var tradeValueTapGestureRecognizer = UITapGestureRecognizer()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateSortIcons),
                                               name: .updateSortIconsNotification,
                                               object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func updateSortIcons() {
        nameSortIcon.image = viewModel?.nameSort.image
        priceSortIcon.image = viewModel?.priceSort.image
        fluctuationSortIcon.image = viewModel?.fluctuationSort.image
        tradeValueSortIcon.image = viewModel?.tradeValueSort.image
    }
    
    func configure(_ viewModel: MainListHeaderViewModel) {
        self.viewModel = viewModel
        resizeIcons()
        layoutLabels()
        layoutStackViews()
        addGestureRecognizers(viewModel)
    }
}

extension MainListHeader {
    
    private func layoutStackViews() {
        
        addSubview(headerStackView)
        headerStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        nameStackView.snp.makeConstraints {
            $0.width.equalTo(headerStackView.snp.width).multipliedBy(0.25)
        }
        fluctuationStackView.snp.makeConstraints {
            $0.width.equalTo(headerStackView.snp.width).multipliedBy(0.2)
        }
        tradeValueStackView.snp.makeConstraints {
            $0.width.equalTo(headerStackView.snp.width).multipliedBy(0.25)
        }
        
        nameStackView.alignment = .center
        priceStackView.alignment = .center
        fluctuationStackView.alignment = .center
        tradeValueStackView.alignment = .center
    }
    
    private func layoutLabels() {
        nameLabel.textAlignment = .left
        priceLabel.textAlignment = .right
        fluctuationLabel.textAlignment = .right
        tradeValueLabel.textAlignment = .right
        
        nameSortIcon.setContentHuggingPriority(.defaultLow, for: .horizontal)
        nameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private func resizeIcons() {
        NSLayoutConstraint.activate([
            nameSortIcon.heightAnchor.constraint(equalToConstant: 12),
            priceSortIcon.heightAnchor.constraint(equalToConstant: 12),
            fluctuationSortIcon.heightAnchor.constraint(equalToConstant: 12),
            tradeValueSortIcon.heightAnchor.constraint(equalToConstant: 12),
            nameSortIcon.widthAnchor.constraint(equalToConstant: 6),
            priceSortIcon.widthAnchor.constraint(equalToConstant: 6),
            fluctuationSortIcon.widthAnchor.constraint(equalToConstant: 6),
            tradeValueSortIcon.widthAnchor.constraint(equalToConstant: 6)
        ])
    }
    
    private func addGestureRecognizers(_ viewModel: MainListHeaderViewModel) {
        nameStackView.addGestureRecognizer(nameTapGestureRecognizer)
        priceStackView.addGestureRecognizer(priceTapGestureRecognizer)
        fluctuationStackView.addGestureRecognizer(fluctuationTapGestureRecognizer)
        tradeValueStackView.addGestureRecognizer(tradeValueTapGestureRecognizer)
        
        nameTapGestureRecognizer.addTarget(viewModel, action: #selector(viewModel.sortName))
        priceTapGestureRecognizer.addTarget(viewModel, action: #selector(viewModel.sortPrice))
        fluctuationTapGestureRecognizer.addTarget(viewModel, action: #selector(viewModel.sortFluctuation))
        tradeValueTapGestureRecognizer.addTarget(viewModel, action: #selector(viewModel.sortTradeValue))
    }
}
