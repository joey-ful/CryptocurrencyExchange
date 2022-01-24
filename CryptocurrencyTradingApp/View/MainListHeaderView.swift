//
//  MainListHeaderView.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/22.
//

import UIKit

class MainListHeaderView: UITableViewHeaderFooterView {
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
    private var sorts: [Sort] = [.none, .none, .none, .down]
    private var sortingMethods: [((Sort) -> Void)?] = []
    
    
    func configure(sortName: ((Sort) -> Void)?,
                   sortPrice: ((Sort) -> Void)?,
                   sortFluctuation: ((Sort) -> Void)?,
                   sortTradeValue: ((Sort) -> Void)?)
    {
        resizeIcons()
        layoutLabels()
        layoutStackViews()
        addGestureRecognizers(sortingMethods: [sortName, sortPrice, sortFluctuation, sortTradeValue])
    }
}

extension MainListHeaderView {
    
    private func layoutStackViews() {
        addSubview(headerStackView)
        headerStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        NSLayoutConstraint.activate([
            fluctuationStackView.widthAnchor.constraint(equalToConstant: 75),
            tradeValueStackView.widthAnchor.constraint(equalToConstant: 85)
        ])
        
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
}

extension MainListHeaderView {
    
    private func addGestureRecognizers(sortingMethods: [((Sort) -> Void)?]) {
        self.sortingMethods = sortingMethods
        
        nameStackView.addGestureRecognizer(nameTapGestureRecognizer)
        priceStackView.addGestureRecognizer(priceTapGestureRecognizer)
        fluctuationStackView.addGestureRecognizer(fluctuationTapGestureRecognizer)
        tradeValueStackView.addGestureRecognizer(tradeValueTapGestureRecognizer)
        
        nameTapGestureRecognizer.addTarget(self, action: #selector(sortNameTapped))
        priceTapGestureRecognizer.addTarget(self, action: #selector(sortPriceTapped))
        fluctuationTapGestureRecognizer.addTarget(self, action: #selector(sortFluctuationTapped))
        tradeValueTapGestureRecognizer.addTarget(self, action: #selector(sortTradeValueTapped))
    }
    
    @objc private func sortNameTapped() {
        updateSorts(targetIndex: 0)
    }
    
    @objc private func sortPriceTapped() {
        updateSorts(targetIndex: 1)
    }
    
    @objc private func sortFluctuationTapped() {
        updateSorts(targetIndex: 2)
    }
    
    @objc private func sortTradeValueTapped() {
        updateSorts(targetIndex: 3)
    }
    
    private func updateSorts(targetIndex: Int) {
        sorts = sorts.enumerated().map { index, value in
            if index == targetIndex {
                return sorts[targetIndex] == .down ? .up : .down
            } else {
                return .none
            }
        }
        sortingMethods[targetIndex]?(sorts[targetIndex])
        
        nameSortIcon.image = sorts[0].image
        priceSortIcon.image = sorts[1].image
        fluctuationSortIcon.image = sorts[2].image
        tradeValueSortIcon.image = sorts[3].image
    }
}
