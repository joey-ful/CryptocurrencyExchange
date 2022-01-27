//
//  TransactionsViewController.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/25.
//

import UIKit

typealias TransactionsDataSource = UITableViewDiffableDataSource<Int, Transaction>

class TransactionsViewController: UIViewController {
    private var viewModel: TransactionsViewModel
    private let coinType: CoinType
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private var dataSource: TransactionsDataSource?
    private let isTime: Bool
    
    init(coin: CoinType, isTime: Bool) {
        self.viewModel = TransactionsViewModel(coinType: coin, isTime: isTime)
        coinType = coin
        self.isTime = isTime
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isTime {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(makeSnapshot),
                                                   name: .restAPITransactionsNotification,
                                                   object: nil)
        } else {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(makeSnapshot),
                                                   name: .candlestickNotification,
                                                   object: nil)
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(makeSnapshot),
                                                   name: .restAPITickerNotification,
                                                   object: nil)
        }
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isTime == false { return }
        viewModel.initiateTimeWebSocket()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(makeSnapshot),
                                               name: .webSocketTransactionsNotification,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if isTime {
            NotificationCenter.default.removeObserver(self,
                                                      name: .restAPITransactionsNotification,
                                                      object: nil)
            NotificationCenter.default.removeObserver(self,
                                                      name: .webSocketTransactionsNotification,
                                                      object: nil)
        } else {
            NotificationCenter.default.removeObserver(self,
                                                      name: .candlestickNotification,
                                                      object: nil)
            NotificationCenter.default.removeObserver(self,
                                                      name: .restAPITickerNotification,
                                                      object: nil)
        }
    }
}

extension TransactionsViewController {

    @objc private func makeSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Transaction>()
        snapshot.appendSections([0])
        snapshot.appendItems(isTime ?  viewModel.transactions : viewModel.dayTransactions, toSection: 0)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func configureTableView() {
        setUpTableView()
        setTableViewAutoLayout()
        createDataSource()
    }
    
    private func setUpTableView() {
        tableView.register(TransactionsCell.self,
                           forCellReuseIdentifier: "transactionsCell")
        tableView.register(TransactionsHeader.self,
                           forHeaderFooterViewReuseIdentifier: "transactionsTimeHeader")
    }
    
    private func setTableViewAutoLayout() {
        view.addSubview(tableView)
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.estimatedRowHeight = UIFont.preferredFont(forTextStyle: .subheadline).pointSize + 30
    }

    private func createDataSource() {
        dataSource = TransactionsDataSource(tableView: tableView,
                                            cellProvider: { tableView, indexPath, itemIdentifier in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "transactionsCell")
                    as? TransactionsCell
            else { return UITableViewCell() }
            
            cell.configure(isTimeCell: self.isTime,
                           viewModel: self.isTime
                           ? self.viewModel.transactionViewModel(at: indexPath.row)
                           : self.viewModel.dayTransactionViewModel(at: indexPath.row))
            
            return cell
        })

        tableView.dataSource = dataSource
    }
}

extension TransactionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "transactionsTimeHeader")
                as? TransactionsHeader
        else { return UITableViewHeaderFooterView() }
        
        header.configure(isTimeCell: isTime)
        
        return header
    }
}
