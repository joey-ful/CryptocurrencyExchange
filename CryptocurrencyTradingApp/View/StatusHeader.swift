//
//  StatusHeader.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/29.
//

import UIKit
import SnapKit

class StatusHeader: UITableViewHeaderFooterView {
    private var viewModel: AssetStatusHeaderViewModel?
    private let nameLabel = UILabel.makeLabel(font: .caption1, text: "자산", color: .systemGray)
    private let withdrawLabel = UILabel.makeLabel(font: .caption1, text: "입금", color: .systemGray)
    private let depositLabel = UILabel.makeLabel(font: .caption1, text: "출금", color: .systemGray)
    
    private var nameSortIcon = UIImageView(image: Sort.none.image)
    private var withdrawSortIcon = UIImageView(image: Sort.none.image)
    private var depositSortIcon = UIImageView(image: Sort.none.image)
    
    private lazy var nameStackView = UIStackView.makeStackView(distribution: .fill,
                                                               spacing: 5,
                                                               subviews: [nameLabel, nameSortIcon])
    private lazy var withdrawStackView = UIStackView.makeStackView(distribution: .fill,
                                                                spacing: 5,
                                                                subviews: [withdrawLabel, withdrawSortIcon])
    private lazy var depositStackView = UIStackView.makeStackView(distribution: .fill,
                                                                      spacing: 5,
                                                                      subviews: [depositLabel,
                                                                                 depositSortIcon])
    private lazy var headerStackView = UIStackView.makeStackView(subviews: [
        nameStackView,
        withdrawStackView,
        depositStackView
    ])

    private var nameTapGestureRecognizer = UITapGestureRecognizer()
    private var withdrawTapGestureRecognizer = UITapGestureRecognizer()
    private var depositTapGestureRecognizer = UITapGestureRecognizer()
    
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
        withdrawSortIcon.image = viewModel?.withdrawSort.image
        depositSortIcon.image = viewModel?.depositSort.image
    }
    
    func configure(_ viewModel: AssetStatusHeaderViewModel) {
        self.viewModel = viewModel
        resizeIcons()
        layoutLabels()
        layoutStackViews()
        addGestureRecognizers(viewModel)
    }
}

extension StatusHeader {
    
    private func layoutStackViews() {
        
        addSubview(headerStackView)
        headerStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        nameStackView.snp.makeConstraints { $0.width.equalToSuperview().multipliedBy(0.5) }
        withdrawLabel.snp.makeConstraints { $0.width.equalToSuperview().multipliedBy(0.25) }
        depositLabel.snp.makeConstraints { $0.width.equalToSuperview().multipliedBy(0.25) }

        nameStackView.alignment = .leading
        withdrawStackView.alignment = .center
        depositStackView.alignment = .center
    }
    
    private func layoutLabels() {
        nameLabel.textAlignment = .left
        
        nameSortIcon.setContentHuggingPriority(.defaultLow, for: .horizontal)
        nameLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private func resizeIcons() {
        NSLayoutConstraint.activate([
            nameSortIcon.heightAnchor.constraint(equalToConstant: 12),
            withdrawSortIcon.heightAnchor.constraint(equalToConstant: 12),
            depositSortIcon.heightAnchor.constraint(equalToConstant: 12),
            nameSortIcon.widthAnchor.constraint(equalToConstant: 6),
            withdrawSortIcon.widthAnchor.constraint(equalToConstant: 6),
            depositSortIcon.widthAnchor.constraint(equalToConstant: 6),
        ])
    }
    
    private func addGestureRecognizers(_ viewModel: AssetStatusHeaderViewModel) {
        nameStackView.addGestureRecognizer(nameTapGestureRecognizer)
        withdrawStackView.addGestureRecognizer(withdrawTapGestureRecognizer)
        depositStackView.addGestureRecognizer(depositTapGestureRecognizer)
        
        nameTapGestureRecognizer.addTarget(viewModel, action: #selector(viewModel.sortName))
        withdrawTapGestureRecognizer.addTarget(viewModel, action: #selector(viewModel.sortWithdraw))
        depositTapGestureRecognizer.addTarget(viewModel, action: #selector(viewModel.sortDeposit))
    }
}
