//
//  OrderInfoCell.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/29.
//

import UIKit
import SnapKit

class OrderInfoCell: UITableViewCell {
    private var titleLabel = UILabel.makeLabel(font: .caption1, color: .systemGray)
    private var valueLabel = UILabel.makeLabel(font: .caption1, color: .systemGray)
    private lazy var separator: UIView = {
        let view = UIView()
        addSubview(view)
        view.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.height.equalTo(0.5)
            $0.width.equalToSuperview()
        }
        view.backgroundColor = .systemGray
        view.isHidden = true
        return view
    }()
    private lazy var cellStackView = UIStackView.makeStackView(alignment: .center,
                                                               subviews: [titleLabel, valueLabel])
    
    func configure(data: (title: String, value: String), valueType: String) {
        configureData(with: data, valueType: valueType)
        layoutStackView()
        layoutViews(data.title)
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
    
    private func layoutViews(_ value: String) {
        titleLabel.textAlignment = .left
        valueLabel.textAlignment = .right
        
        titleLabel.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.35)
            $0.top.equalToSuperview().offset(3)
            $0.bottom.equalToSuperview().offset(-3)
        }
        valueLabel.snp.makeConstraints { $0.width.equalToSuperview().multipliedBy(0.65) }
        
        if value == "separator" {
            cellStackView.isHidden = true
            separator.isHidden = false
        }
    }
    
    private func configureData(with data: (title: String, value: String), valueType: String) {
        titleLabel.text = data.title
        valueLabel.text = data.value
        
        if valueType == "high" {
            valueLabel.textColor = .systemRed.withAlphaComponent(0.7)
        } else if valueType == "low" {
            valueLabel.textColor = .systemBlue.withAlphaComponent(0.7)
        }
    }
    
    override func prepareForReuse() {
        cellStackView.isHidden = false
        separator.isHidden = true
        titleLabel.textColor = .systemGray
        valueLabel.textColor = .systemGray
    }
}
