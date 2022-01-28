//
//  OrderViewController.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/28.
//

import UIKit
import SnapKit

typealias OrderDataSource = UITableViewDiffableDataSource<Int, Order>

class OrderViewController: UIViewController {
    private let viewModel: OrdersViewModel
    private var orderDataSource: OrderDataSource?
    private var minusButton = UIButton.makeButton(imageSymbol: "minus.square")
    private var unitLabel = UILabel.makeLabel(font: .body, text: "1000")
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
    
    init(viewModel: OrdersViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        configureTableView()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(initializeOrderSnapshot),
                                               name: .restAPIOrderNotification,
                                               object: nil)
    }

    private func setUpUI() {
        view.backgroundColor = .white
        view.addSubview(selectionStackView)
        view.addSubview(orderTableView)
        view.addSubview(summaryStackView)
        view.addSubview(volumePowerTableView)
        
        selectionStackView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.65).offset(-20)
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
        }
        
        minusButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.15)
        }
        
        plusButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.15)
        }
        
        unitLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        unitLabel.textAlignment = .center
        
        orderTableView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.65).offset(-20)
            make.top.equalTo(selectionStackView.snp.bottom)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        summaryStackView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.35)
            make.height.equalToSuperview().multipliedBy(0.4)
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
        }

        volumePowerTableView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.35)
            make.top.equalTo(summaryStackView.snp.bottom)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

extension OrderViewController {
    
    private func configureTableView() {
        setUpTableView()
        registerCell()
    }
    
    @objc private func initializeOrderSnapshot() {
        makeOrderSnapshot()
        let middleIndexPath = IndexPath(row: viewModel.middleIndex, section: 0)
        orderTableView.scrollToRow(at: middleIndexPath, at: .middle, animated: false)
    }
    
    @objc private func makeOrderSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Order>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.orders, toSection: 0)
        orderDataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func setUpTableView() {
        orderTableView.register(OrderCell.self, forCellReuseIdentifier: "orderCell")
    }
    
    private func registerCell() {
        orderDataSource = OrderDataSource(tableView: orderTableView,
                                        cellProvider: { tableView, indexPath, mainListCoin in

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell",
                                                           for: indexPath) as? OrderCell else {
                return UITableViewCell()
            }

            let orderViewModel = self.viewModel.orderViewModel(at: indexPath.row)
            cell.configure(orderViewModel)

            return cell
        })
        orderTableView.dataSource = orderDataSource
    }
}
