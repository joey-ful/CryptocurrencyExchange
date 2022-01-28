//
//  OrderViewController.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/28.
//

import UIKit
import SnapKit

class OrderViewController: UIViewController {
    private var minusButton = UIButton.makeButton(imageSymbol: "minus.square")
    private var unitLabel = UILabel.makeLabel(font: .callout, text: "1000")
    private var plusButton = UIButton.makeButton(imageSymbol: "plus.square")
    private lazy var selectionStackView = UIStackView.makeStackView(alignment: .center,
                                                                    subviews: [minusButton,
                                                                               unitLabel,
                                                                               plusButton])
    private let orderTableView = UITableView(frame: .zero, style: .plain)
    private var quantityLabel = UILabel.makeLabel()
    private var tradeValueLabel = UILabel.makeLabel()
    private var separator = UIView()
    private var prevClosePriceLabel = UILabel.makeLabel()
    private var openPriceLabel = UILabel.makeLabel()
    private var highPriceLabel = UILabel.makeLabel()
    private var lowPriceLabelLabel = UILabel.makeLabel()
    private lazy var summaryStackView = UIStackView.makeStackView(alignment: .leading,
                                                             axis: .vertical,
                                                             spacing: 5,
                                                             subviews: [
                                                                quantityLabel,
                                                                tradeValueLabel,
                                                                separator,
                                                                prevClosePriceLabel,
                                                                openPriceLabel,
                                                                highPriceLabel,
                                                                lowPriceLabelLabel
                                                             ])
    private let volumePowerTableView = UITableView(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
    }
    
    private func setUpUI() {
        layoutViews()
    }

    private func layoutViews() {
        view.backgroundColor = .white
        view.addSubview(selectionStackView)
        view.addSubview(orderTableView)
        view.addSubview(summaryStackView)
        view.addSubview(volumePowerTableView)
        
        selectionStackView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.65)
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalTo(orderTableView)
        }
        
        orderTableView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.65)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        summaryStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(volumePowerTableView)
            make.width.equalToSuperview().multipliedBy(0.35)
        }
        
        volumePowerTableView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.35)
        }
    }
    
    
}
