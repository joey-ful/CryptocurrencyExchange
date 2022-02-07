//
//  DetailChartViewController.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/01/30.
//

import UIKit
import SnapKit
import SwiftUI

class DetailChartViewController: UIViewController {
    private let coin: CoinType?
    private var chartView: ChartView?
    
    private lazy var hostingController: UIHostingController<ChartView?> = {
        let controller = UIHostingController(rootView: chartView)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        return controller
    }()
    
    private lazy var timeControl: UISegmentedControl = {
        let items = ["1분","10분","30분","1시간","일"]
        let timeControl = UISegmentedControl(items: items)
        timeControl.selectedSegmentIndex = 0
        timeControl.layer.borderColor = UIColor.gray.cgColor
        timeControl.addTarget(self, action: #selector(menuSelect), for: .valueChanged)
        timeControl.layer.masksToBounds = true
        return timeControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    init(coin: CoinType) {
        self.coin = coin
        chartView = ChartView(coin: coin, chartIntervals: .oneMinute)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func menuSelect(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            chartView?.viewModel.initiateViewModel(coin: coin ?? .btc
                                                  , chartIntervals: .oneMinute)
        case 1:
            chartView?.viewModel.initiateViewModel(coin: coin ?? .btc
                                                  , chartIntervals: .tenMinute)
        case 2:
            chartView?.viewModel.initiateViewModel(coin: coin ?? .btc
                                                  , chartIntervals: .thirtyMinute)
        case 3:
            chartView?.viewModel.initiateViewModel(coin: coin ?? .btc
                                                  , chartIntervals: .oneHour)
        case 4:
            chartView?.viewModel.initiateViewModel(coin: coin ?? .btc
                                                  , chartIntervals: .twentyFourHour)
        default:
            chartView?.viewModel.initiateViewModel(coin: coin ?? .btc
                                                  , chartIntervals: .twentyFourHour)
        }
    }
    
    private func setLayout() {
        addChild(hostingController)
        view.addSubview(timeControl)
        view.addSubview(hostingController.view)
        
        timeControl.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.top.equalToSuperview()
                make.bottom.equalTo(hostingController.view.snp.top)
                make.width.equalToSuperview()
                make.height.equalToSuperview().multipliedBy(0.03)
            }
            
            hostingController.didMove(toParent: self)
            hostingController.view.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.top.equalTo(timeControl.snp.bottom)
                make.bottom.equalToSuperview()
                make.height.equalTo(view.safeAreaLayoutGuide.snp
                                        .height).multipliedBy(0.60)
                
                
            }
        }
        
        
        
    }