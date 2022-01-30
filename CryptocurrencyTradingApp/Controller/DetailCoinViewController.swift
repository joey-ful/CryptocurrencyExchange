//
//  File.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/01/30.
//

import UIKit
import SnapKit
import SwiftUI

class DetailCoinViewController: UIViewController {
    var containerView = UIView()
    var viewModel: DetailCoinViewModel!
    let coin: CoinType?
    
    let priceLabel = UILabel.makeLabel(font: .title1)
    let incrementLabel = UILabel.makeLabel(font: .caption1)
    let percentLabel = UILabel.makeLabel(font: .caption1)
    let items = ["차트","호가","시세"]
    
    lazy var headerHorizontalStackView = UIStackView.makeStackView(alignment: .leading, distribution: .fillEqually, axis: .horizontal, spacing: 1, subviews: [incrementLabel, percentLabel])
    
    
    lazy var headerVerticalStackView = UIStackView.makeStackView(alignment: .leading, distribution: .fillEqually, axis: .vertical, spacing: 1, subviews: [priceLabel, headerHorizontalStackView])
    
    var controller: UIHostingController<ChartView> = {
        let chartView = ChartView(coin: .btc, chartIntervals: .oneMinute)
        let controller = UIHostingController(rootView: chartView)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        return controller
    }()
    
    
    lazy var menuControl: UISegmentedControl = {
        let menuControl = UISegmentedControl(items: items)
        menuControl.selectedSegmentIndex = 0
        menuControl.layer.borderColor = UIColor.gray.cgColor
        menuControl.addTarget(self, action: #selector(menuSelect), for: .valueChanged)
        menuControl.layer.masksToBounds = true
        return menuControl
    }()
    
    var chartView = UIHostingController(rootView: ChartView(coin: .btc, chartIntervals: .oneMinute))
    
    let chartViewController = DetailChartViewController()
    lazy var transactionVC = TransactionsViewController(coin: coin ?? .btc, isTime: true)
    lazy var orderViewController = OrderViewController(coin: coin ?? .btc)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationItem()
        setLayout()
        NotificationCenter.default.addObserver(self, selector: #selector(setDataForLabel), name: .coinDetailNotificaion, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateContainverView), name: .coinChartDataReceiveNotificaion, object: nil)
        
    }

    init(coin: CoinType) {
        self.coin = coin
        viewModel = DetailCoinViewModel(coin: coin)
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func updateContainverView() {
        containerView.addSubview(chartViewController.view)
    }

    @objc func setDataForLabel() {

        priceLabel.text = viewModel.coinInfomation?.currentPrice.toDecimal()
        incrementLabel.text = viewModel.coinInfomation?.fluctuationAmount.toDecimal()
        percentLabel.text = viewModel.coinInfomation?.fluctuationRate
    }
    
    @objc func addTapped(_ sender: Any) {
        navigationItem.rightBarButtonItem?.isSelected.toggle()
        UserDefaults.standard.set(navigationItem.rightBarButtonItem?.isSelected, forKey: "coin")
    }
    
    @objc func menuSelect(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            transactionVC.view.removeFromSuperview()
            orderViewController.view.removeFromSuperview()
            containerView.addSubview(chartViewController.view)
        case 1:
            transactionVC.view.removeFromSuperview()
            containerView.addSubview(orderViewController.view)
        case 2:
            orderViewController.view.removeFromSuperview()
            containerView.addSubview(transactionVC.view)
        default:
            containerView.removeFromSuperview()
        }
    }
    
    func setNavigationItem() {
        self.title = coin?.rawValue.uppercased()
        self.navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .save, target: self, action: #selector(addTapped))
    }
    
    func setLayout() {
        view.backgroundColor = .white
        view.addSubview(menuControl)
        view.addSubview(containerView)
        view.addSubview(headerVerticalStackView)
        headerVerticalStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
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
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(menuControl.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.85)
            make.right.equalToSuperview()
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
}
