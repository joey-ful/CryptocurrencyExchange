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
    private let orderInfoViewModel: RestAPITickerViewModel
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
    private var transactionTableView = UITableView(frame: .zero, style: .plain)
    private let orderInfoTableView = UITableView(frame: .zero, style: .plain)
    
    init(coin: CoinType) {
        ordersViewModel = OrdersViewModel(coin: coin)
        transactionsViewModel = TransactionsViewModel(coinType: coin, isTime: true)
        orderInfoViewModel = RestAPITickerViewModel(coin: coin)
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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(initInfoData),
                                               name: .restAPITickerNotification,
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
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .webSocketTransactionsNotification, object: nil)
    }
}

// MARK: UI
extension OrderViewController {
    
    @objc private func initInfoData() {
        orderInfoTableView.reloadData()
    }

    private func setUpUI() {
        view.backgroundColor = .white
        view.addSubview(selectionStackView)
        view.addSubview(orderTableView)
        view.addSubview(orderInfoTableView)
        view.addSubview(transactionTableView)
        
        selectionStackView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.6).offset(-20)
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
            make.width.equalToSuperview().multipliedBy(0.6).offset(-20)
            make.top.equalTo(selectionStackView.snp.bottom)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
//        orderTableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

        transactionTableView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.4).offset(-10)
            make.height.equalToSuperview().multipliedBy(0.6)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview()
        }
        
        orderInfoTableView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.4).offset(-10)
            make.height.equalToSuperview().multipliedBy(0.2)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalTo(transactionTableView.snp.top)
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
        transactionTableView.separatorStyle = .none
        orderInfoTableView.register(OrderInfoCell.self, forCellReuseIdentifier: "infoCell")
        orderInfoTableView.dataSource = self
        orderInfoTableView.separatorStyle = .none
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

extension OrderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderInfoViewModel.infoListCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell") as? OrderInfoCell else { return UITableViewCell() }
        
        cell.configure(data: orderInfoViewModel.infoList[indexPath.row],
                       valueType: orderInfoViewModel.valueType(at: indexPath.row))
        
        return cell
    }
    
    
}
