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
    private let viewModel: ChartViewModel
    private lazy var chartView: CombinedChartView = {
        var chartView = CombinedChartView()
        chartView.rightAxis.setLabelCount(5, force: true)
        chartView.leftAxis.enabled = false
        chartView.legend.enabled = false
        chartView.leftAxis.enabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.setLabelCount(4, force: true)
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
    
    init(coin: CoinType) {
        self.viewModel = ChartViewModel(coin: coin, chartIntervals: .oneMinute)
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setLayoutForChartView()
        setData()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(initChart),
                                               name: .candleChartDataNotification,
                                               object: nil)
    }
    
    @objc private func menuSelect(_ sender: UISegmentedControl) {
            switch sender.selectedSegmentIndex {
            case 0:
                viewModel.initiateViewModel(chartIntervals: .oneMinute)
            case 1:
                viewModel.initiateViewModel(chartIntervals: .tenMinute)
            case 2:
                viewModel.initiateViewModel(chartIntervals: .thirtyMinute)
            case 3:
                viewModel.initiateViewModel(chartIntervals: .oneHour)
            case 4:
                viewModel.initiateViewModel(chartIntervals: .twentyFourHour)
            default:
                viewModel.initiateViewModel(chartIntervals: .oneMinute)
            }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

    @objc private func initChart() {
        setData()
        setChart()
    }
    
    private func setData() {
        let candleStickData = viewModel.candleDataSet
        candleStickData.increasingColor = .red
        candleStickData.decreasingColor = .blue
        candleStickData.shadowColorSameAsCandle = true
        candleStickData.decreasingFilled = true
        candleStickData.increasingFilled = true
        candleStickData.valueTextColor = .clear
        
        let lineData = viewModel.lineDataSet
        lineData.valueTextColor = .clear
        lineData.circleColors = [.orange]
        lineData.colors = [.orange]
        lineData.mode = .cubicBezier
        lineData.circleRadius = .zero
        
        let chartViewData = CombinedChartData()
        chartViewData.candleData = CandleChartData(dataSet: candleStickData)
        chartViewData.lineData = LineChartData(dataSet: lineData)
        chartView.data = chartViewData
    }

    private func setChart() {
        chartView.xAxis.setLabelCount(4, force: true)
        chartView.xAxis.axisMaximum = viewModel.maximumDate
        chartView.xAxis.axisMinimum = viewModel.minimumDate
        chartView.rightAxis.valueFormatter = ChartYAxisFormatter()
        chartView.xAxis.valueFormatter = ChartXAxisFormatter(referenceTimeInterval: viewModel.minimumTimeInterval, multiplier: viewModel.multiplier)
        guard let lastData = viewModel.candleDataSet.last else { return }
        chartView.zoomOut()
        chartView.zoom(scaleX: viewModel.scaleX, scaleY: viewModel.scaleY, xValue: lastData.x, yValue: viewModel.medianY, axis: .right)
    }
}
