//
//  OrderViewController.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/28.
//

import UIKit
import SnapKit

typealias OrderDataSource = UITableViewDiffableDataSource<Int, Order>
typealias TransactionDataSource = UITableViewDiffableDataSource<Int, Transaction>

class OrderViewController: UIViewController {
    private let ordersViewModel: OrdersViewModel
    private let transactionsViewModel: TransactionsViewModel
    private var orderDataSource: OrderDataSource?
    private var transactionDataSource: TransactionDataSource?
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
    private let volumePowerTitleLabel = UILabel.makeLabel(font: .caption1, text: "체결강도", color: .systemGray)
    private var volumePowerValueLabel = UILabel.makeLabel(font: .caption1)
    private lazy var volumePowerStackView = UIStackView.makeStackView(alignment: .center,
                                                                      spacing: 5,
                                                                      subviews: [volumePowerTitleLabel,
                                                                                 volumePowerValueLabel])
    private var transactionTableView = UITableView(frame: .zero, style: .plain)
    
    init(ordersViewModel: OrdersViewModel, transactionsViewModel: TransactionsViewModel) {
        self.ordersViewModel = ordersViewModel
        self.transactionsViewModel = transactionsViewModel
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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(makeTransactionSnapshot),
                                               name: .restAPITransactionsNotification,
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ordersViewModel.initiateWebSocket()
        transactionsViewModel.initiateTimeWebSocket()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(makeTransactionSnapshot),
                                               name: .webSocketTransactionsNotification,
                                               object: nil)
    }
}

// MARK: UI
extension OrderViewController {

    private func setUpUI() {
        view.backgroundColor = .white
        view.addSubview(selectionStackView)
        view.addSubview(orderTableView)
        view.addSubview(summaryStackView)
        view.addSubview(volumePowerStackView)
        view.addSubview(transactionTableView)
        selectionStackView.backgroundColor = .systemPink
        orderTableView.backgroundColor = .systemPurple
        summaryStackView.backgroundColor = .systemCyan
        volumePowerStackView.backgroundColor = .systemMint
        transactionTableView.backgroundColor = .systemBlue
        
        
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
            make.width.equalToSuperview().multipliedBy(0.35).offset(-10)
            make.height.equalToSuperview().multipliedBy(0.4)
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
        }
        
        volumePowerStackView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.35).offset(-10)
            make.top.equalTo(summaryStackView.snp.bottom)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        volumePowerTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }

        transactionTableView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.35).offset(-10)
            make.top.equalTo(volumePowerStackView.snp.bottom)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: TableView
extension OrderViewController {
    
    private func configureTableView() {
        setUpTableView()
        registerCell()
    }
    
    @objc private func initializeOrderSnapshot() {
        makeOrderSnapshot()
        let middleIndexPath = IndexPath(row: ordersViewModel.middleIndex, section: 0)
        orderTableView.scrollToRow(at: middleIndexPath, at: .middle, animated: false)
    }
    
    @objc private func makeOrderSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Order>()
        snapshot.appendSections([0])
        snapshot.appendItems(ordersViewModel.orders, toSection: 0)
        orderDataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    @objc private func makeTransactionSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Transaction>()
        snapshot.appendSections([0])
        let data = Array(transactionsViewModel.transactions.prefix(30))
        snapshot.appendItems(data, toSection: 0)
        transactionDataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func setUpTableView() {
        orderTableView.register(OrderCell.self, forCellReuseIdentifier: "orderCell")
        transactionTableView.register(OrderTransactionCell.self, forCellReuseIdentifier: "transactionCell")
    }
    
    private func registerCell() {
        orderDataSource = OrderDataSource(tableView: orderTableView,
                                        cellProvider: { tableView, indexPath, mainListCoin in

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell",
                                                           for: indexPath) as? OrderCell else {
                return UITableViewCell()
            }

            let orderViewModel = self.ordersViewModel.orderViewModel(at: indexPath.row)
            cell.configure(orderViewModel)

            return cell
        })
        orderTableView.dataSource = orderDataSource
        
        transactionDataSource = TransactionDataSource(tableView: transactionTableView,
                                        cellProvider: { tableView, indexPath, mainListCoin in

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell",
                                                           for: indexPath) as? OrderTransactionCell else {
                return UITableViewCell()
            }

            let transactionViewModel = self.transactionsViewModel.transactionViewModel(at: indexPath.row)
            cell.configure(viewModel: transactionViewModel)

            return cell
        })
        transactionTableView.dataSource = transactionDataSource
    }
}
