//
//  OrderViewController.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/28.
//

import UIKit
import SnapKit

class OrderViewController: UIViewController {
    private let ordersViewModel: OrdersViewModel
    private let transactionsViewModel: TransactionsViewModel
    private let orderInfoViewModel: RestAPITickerViewModel
    private let orderTableView = UITableView(frame: .zero, style: .plain)
    private var transactionTableView = UITableView(frame: .zero, style: .plain)
    private let orderInfoTableView = UITableView(frame: .zero, style: .plain)
    
    init(_ market: UpbitMarket) {
        ordersViewModel = OrdersViewModel(market)
        transactionsViewModel = TransactionsViewModel(market)
        orderInfoViewModel = RestAPITickerViewModel(market)
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
                                               selector: #selector(initInfoData),
                                               name: .restAPITickerNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveScrollToMiddle), name: .moveScrollToMiddleNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ordersViewModel.initiateWebSocket()
        transactionsViewModel.initiateTimeWebSocket()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ordersViewModel.closeWebSocket()
        transactionsViewModel.closeWebSocket()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .restAPITickerNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .moveScrollToMiddleNotification, object: nil)
    }
}

// MARK: UI
extension OrderViewController {
    
    @objc private func initInfoData() {
        DispatchQueue.main.async { [weak self] in
            self?.orderInfoTableView.reloadData()
        }
    }
    
    @objc private func moveScrollToMiddle() {
            let middleIndexPath = IndexPath(row: ordersViewModel.middleIndex, section: 0)
        DispatchQueue.main.async { [weak self] in
            self?.orderTableView.scrollToRow(at: middleIndexPath, at: .middle, animated: false)
        }
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
    
    private func setUpTableView() {
        orderTableView.register(OrderCell.self, forCellReuseIdentifier: "orderCell")
        transactionTableView.register(OrderTransactionCell.self, forCellReuseIdentifier: "transactionCell")
        transactionTableView.separatorStyle = .none
        orderInfoTableView.register(OrderInfoCell.self, forCellReuseIdentifier: "infoCell")
        orderInfoTableView.dataSource = self
        orderInfoTableView.separatorStyle = .none
    }
    
    private func registerCell() {
        ordersViewModel.orderDataSource = OrderDataSource(tableView: orderTableView,
                                        cellProvider: { [weak self] tableView, indexPath, mainListCoin in

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell",
                                                           for: indexPath) as? OrderCell,
                  let viewModel = self?.ordersViewModel.orderViewModel(at: indexPath.row) else {
                return UITableViewCell()
            }

            cell.configure(viewModel)

            return cell
        })
        orderTableView.dataSource = ordersViewModel.orderDataSource
        
        transactionsViewModel.transactionDataSource = TransactionDataSource(tableView: transactionTableView,
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
        transactionTableView.dataSource = transactionsViewModel.transactionDataSource
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
