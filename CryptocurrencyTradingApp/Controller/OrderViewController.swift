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
    private let orderTableView = UITableView(frame: .zero, style: .plain)
    private var transactionTableView = UITableView(frame: .zero, style: .plain)
    private let orderInfoTableView = UITableView(frame: .zero, style: .plain)
    private var isInitialization: Bool = true
    
    init(coin: CoinType) {
        ordersViewModel = OrdersViewModel(coin: coin)
        transactionsViewModel = TransactionsViewModel(coinType: coin)
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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(makeOrderSnapshot),
                                               name: .restAPIOrderNotification,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .webSocketTransactionsNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .restAPIOrderNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .restAPITransactionsNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .restAPITickerNotification, object: nil)
    }
}

// MARK: UI
extension OrderViewController {
    
    @objc private func initInfoData() {
        orderInfoTableView.reloadData()
    }

    private func setUpUI() {
        view.backgroundColor = .white
        view.addSubview(orderTableView)
        view.addSubview(orderInfoTableView)
        view.addSubview(transactionTableView)
        
        orderTableView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.6).offset(-20)
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        orderTableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        orderInfoTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.width.equalToSuperview().multipliedBy(0.4).offset(-10)
            make.height.equalTo(view.safeAreaLayoutGuide.snp.height).multipliedBy(0.31)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        transactionTableView.snp.makeConstraints { make in
            make.top.equalTo(orderInfoTableView.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.4).offset(-10)
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
    
    @objc private func makeOrderSnapshot() {
        if isInitialization {
            var snapshot = NSDiffableDataSourceSnapshot<Int, Order>()
            snapshot.appendSections([0])
            snapshot.appendItems(ordersViewModel.orders, toSection: 0)
            orderDataSource?.apply(snapshot, animatingDifferences: false)
            
            let middleIndexPath = IndexPath(row: ordersViewModel.middleIndex, section: 0)
            orderTableView.scrollToRow(at: middleIndexPath, at: .middle, animated: false)
            isInitialization = false
        } else {
            guard var snapshot = orderDataSource?.snapshot() else { return }
            snapshot.reconfigureItems(snapshot.itemIdentifiers)
            orderDataSource?.apply(snapshot, animatingDifferences: true)
        }
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
                                        cellProvider: { [weak self] tableView, indexPath, mainListCoin in

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell",
                                                           for: indexPath) as? OrderCell,
                  let viewModel = self?.ordersViewModel.orderViewModel(at: indexPath.row) else {
                return UITableViewCell()
            }

            cell.configure(viewModel)

            return cell
        })
        orderTableView.dataSource = orderDataSource
        
        transactionDataSource = TransactionDataSource(tableView: transactionTableView,
                                        cellProvider: { [weak self] tableView, indexPath, mainListCoin in

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell",
                                                           for: indexPath) as? OrderTransactionCell,
                  let viewModel = self?.transactionsViewModel.transactionViewModel(at: indexPath.row)
            else {
                return UITableViewCell()
            }

            cell.configure(viewModel: viewModel)

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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell") as? OrderInfoCell else {
            return UITableViewCell()
        }
        
        cell.configure(data: orderInfoViewModel.infoList[indexPath.row],
                       valueType: orderInfoViewModel.valueType(at: indexPath.row))
        
        return cell
    }
}
