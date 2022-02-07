//
//  File.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/01/30.
//

import UIKit
import SnapKit
import SwiftUI

final class DetailCoinViewController: UIViewController {
    private var containerView = UIView()
    private var viewModel: DetailCoinViewModel!
    private let coin: CoinType?
    private let priceLabel = UILabel.makeLabel(font: .title1)
    private let incrementLabel = UILabel.makeLabel(font: .caption1)
    private let percentLabel = UILabel.makeLabel(font: .caption1)
    private let items = ["차트","호가","시세"]
    private lazy var headerHorizontalStackView = UIStackView.makeStackView(alignment: .leading, distribution: .fillEqually, axis: .horizontal, spacing: 3, subviews: [incrementLabel, percentLabel])
    private lazy var headerVerticalStackView = UIStackView.makeStackView(alignment: .leading, distribution: .fillEqually, axis: .vertical, spacing: 1, subviews: [priceLabel, headerHorizontalStackView])
    private lazy var menuControl: UISegmentedControl = {
        let menuControl = UISegmentedControl(items: items)
        menuControl.selectedSegmentIndex = 0
        menuControl.layer.borderColor = UIColor.gray.cgColor
        menuControl.addTarget(self, action: #selector(menuSelect), for: .valueChanged)
        menuControl.layer.masksToBounds = true
        return menuControl
    }()
    private let chartViewController: DetailChartViewController
    private lazy var transactionVC = TransactionsViewController(coin: coin ?? .btc)
    private lazy var orderViewController = OrderViewController(coin: coin ?? .btc)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationItem()
        setLayout()
        NotificationCenter.default.addObserver(self, selector: #selector(setDataForLabel), name: .coinDetailNotificaion, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let coin = coin else { return }
        if viewModel.userDefaults.contains(coin.rawValue) {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star.fill")
        }
    }

    init(coin: CoinType) {
        self.coin = coin
        viewModel = DetailCoinViewModel(coin: coin)
        chartViewController = DetailChartViewController(coin: coin)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func setDataForLabel() {
        priceLabel.text = viewModel.price
        incrementLabel.text = viewModel.fluctuationAmount
        percentLabel.text = viewModel.sign + viewModel.fluctuationRate
        incrementLabel.textColor = viewModel.sign == "+" ? .systemRed : .systemBlue
        percentLabel.textColor = viewModel.sign == "+" ? .systemRed : .systemBlue
    }
    
    @objc func addTapped(_ sender: Any) {
        guard let coin = coin else { return }
        if navigationItem.rightBarButtonItem?.image == UIImage(systemName: "star") {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star.fill")
            viewModel.addToUserDefaults(coin: coin.rawValue)
        } else {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star")
            viewModel.removeFromUserDefaults(coin: coin.rawValue)
        }
    }
    
    @objc private func menuSelect(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            transactionVC.view.removeFromSuperview()
            orderViewController.view.removeFromSuperview()
            addAndLayoutChartView()
        case 1:
            transactionVC.view.removeFromSuperview()
            orderViewController.view.removeFromSuperview()
            addAndLayoutOrderView()
        case 2:
            chartViewController.view.removeFromSuperview()
            orderViewController.view.removeFromSuperview()
            addAndLayoutTransactionView()
        default:
            containerView.removeFromSuperview()
        }
    }
    
    private func setNavigationItem() {
        self.title = coin?.name
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(addTapped))
    }
    
    private func setLayout() {
        view.backgroundColor = .white
        view.addSubview(menuControl)
        view.addSubview(containerView)
        view.addSubview(headerVerticalStackView)
        
        headerVerticalStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(menuControl.snp.top)
            make.height.equalToSuperview().multipliedBy(0.1)
        }
        menuControl.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(containerView.snp.top)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        
        let tabBarHeight = tabBarController?.tabBar.bounds.height ?? .zero
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(menuControl.snp.bottom)
            make.width.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-tabBarHeight)
        }
        
        addAndLayoutChartView()
    }
    
    private func addAndLayoutChartView() {
        containerView.addSubview(chartViewController.view)
        chartViewController.view.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top)
            make.leading.equalTo(containerView.snp.leading)
            make.trailing.equalTo(containerView.snp.trailing)
            make.bottom.equalTo(containerView.snp.bottom)
        }
    }
    
    private func addAndLayoutTransactionView() {
        containerView.addSubview(transactionVC.view)
        transactionVC.view.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top)
            make.leading.equalTo(containerView.snp.leading)
            make.trailing.equalTo(containerView.snp.trailing)
            make.bottom.equalTo(containerView.snp.bottom)
        }
    }
    
    private func addAndLayoutOrderView() {
        containerView.addSubview(orderViewController.view)
        orderViewController.view.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.top)
            make.leading.equalTo(containerView.snp.leading)
            make.trailing.equalTo(containerView.snp.trailing)
            make.bottom.equalTo(containerView.snp.bottom)
        }
    }
}
