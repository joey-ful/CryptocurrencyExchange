//
//  DetailChartViewController.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/01/30.
//

import UIKit
import SnapKit
import Charts

class DetailChartViewController: UIViewController {
    private lazy var chartView: CandleStickChartView = {
        var chartView = CandleStickChartView()
        chartView.rightAxis.setLabelCount(5, force: true)
        chartView.leftAxis.enabled = false
        chartView.legend.enabled = false
        chartView.leftAxis.enabled = false
        chartView.xAxis.labelPosition = .bottom
        return chartView
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
    
    
    
    private var restAPIManager = RestAPIManager()
    private var candleStickData: [[CandleStick.CandleStickData]] = []
    private var data: CandleChartData = CandleChartData()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
  
        requestNetwork()
        setLayoutForChartView()
    }
    
    @objc private func menuSelect(_ sender: UISegmentedControl) {
//            switch sender.selectedSegmentIndex {
//            case 0:
//                chartView?.viewModel.initiateViewModel(coin: coin ?? .btc
//                                                      , chartIntervals: .oneMinute)
//            case 1:
//                chartView?.viewModel.initiateViewModel(coin: coin ?? .btc
//                                                      , chartIntervals: .tenMinute)
//            case 2:
//                chartView?.viewModel.initiateViewModel(coin: coin ?? .btc
//                                                      , chartIntervals: .thirtyMinute)
//            case 3:
//                chartView?.viewModel.initiateViewModel(coin: coin ?? .btc
//                                                      , chartIntervals: .oneHour)
//            case 4:
//                chartView?.viewModel.initiateViewModel(coin: coin ?? .btc
//                                                      , chartIntervals: .twentyFourHour)
//            default:
//                chartView?.viewModel.initiateViewModel(coin: coin ?? .btc
//                                                      , chartIntervals: .twentyFourHour)
//            }
        }
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
    
    private func setLayoutForChartView() {
        view.addSubview(timeControl)
        view.addSubview(chartView)
        
        timeControl.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                make.height.equalToSuperview().multipliedBy(0.03)
            }
        
        chartView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(timeControl.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
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
