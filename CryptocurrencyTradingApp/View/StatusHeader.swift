//
//  StatusHeader.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/29.
//

import UIKit
import SnapKit

class StatusHeader: UITableViewHeaderFooterView {
    private let nameLabel = UILabel.makeLabel(font: .caption1, text: "자산", color: .systemGray)
    private let withdrawLabel = UILabel.makeLabel(font: .caption1, text: "입금", color: .systemGray)
    private let depositLabel = UILabel.makeLabel(font: .caption1, text: "출금", color: .systemGray)
    
    private lazy var headerStackView = UIStackView.makeStackView(subviews: [
        nameLabel,
        withdrawLabel,
        depositLabel
    ])
    
    func configure() {
        addSubview(headerStackView)
        headerStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        nameLabel.snp.makeConstraints { $0.width.equalToSuperview().multipliedBy(0.6) }
        withdrawLabel.snp.makeConstraints { $0.width.equalToSuperview().multipliedBy(0.2) }
        depositLabel.snp.makeConstraints { $0.width.equalToSuperview().multipliedBy(0.2) }

        nameLabel.textAlignment = .left
        withdrawLabel.textAlignment = .center
        depositLabel.textAlignment = .center
    }
}
