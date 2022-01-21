//
//  ViewController.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/17.
//

import UIKit
import SnapKit

typealias MainListDataSource = UITableViewDiffableDataSource<Int, MainListCoin>

class MainListViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .plain)
    private var dataSource: MainListDataSource?
    private var mainListCoins: [MainListCoin] = []
    private var snapshot: NSDiffableDataSourceSnapshot<Int, MainListCoin>?
    private let restAPIManager = RestAPIManager()
    private let webSocketManager = WebsocketManger()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(initializeMainList),
                                               name: .restAPITickerAllNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTradeValue),
                                               name: .webSocketTicker24HNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTransaction),
                                               name: .webSocketTransactionNotification,
                                               object: nil)
        
        restAPIManager.fetch(type: .tickerAll, paymentCurrency: .KRW)
        webSocketManager.connectWebSocket(.transaction, CoinType.allCoins, nil)
        webSocketManager.connectWebSocket(.ticker, CoinType.allCoins, [.twentyfour])
        setUpTableView()
    }

}

extension MainListViewController {
    @objc private func initializeMainList(notification: Notification) {
        if let data = notification.userInfo?["data"] as? [MainListCoin] {
            mainListCoins = data.sorted { $0.tradeValue.toDouble() > $1.tradeValue.toDouble() }
            makeSnapshot()
        }
    }
    
    @objc private func updateTradeValue(notification: Notification) {
        guard let ticker = notification.userInfo?["data"] as? Ticker else { return }
        
        DispatchQueue.main.async { [weak self] in
            self?.mainListCoins.enumerated().forEach { index, oldCoin in
                if self?.mainListCoins[index].symbol == ticker.symbol.replacingOccurrences(of: "_", with: "/") {
                    self?.mainListCoins[index].tradeValue = ticker.accumulatedTradeValue.dividedByMillion() + .million
                    self?.makeSnapshot()
                }
            }
        }
    }
    
        }
    }
    
    @objc private func updateTransaction(notification: Notification) {
        guard let transactions = notification.userInfo?["data"] as? [Transaction] else { return }
        
        DispatchQueue.main.async { [weak self] in
            transactions.forEach { transaction in
                self?.mainListCoins.enumerated().forEach { index, oldCoin in
                    if self?.mainListCoins[index].symbol == transaction.symbol.replacingOccurrences(of: "_", with: "/") {
                        let textColor: UIColor = transaction.upDown == "up" ? .systemRed : .systemBlue
                        self?.mainListCoins[index].currentPrice = transaction.price.toDecimal()
                        self?.makeSnapshot()
                        (self?.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? MainListTableViewCell)?.blink(in: textColor)
                    }
                }
            }
        }
    }
}

extension MainListViewController {
    private func setUpTableView() {
        setTableViewAutoLayout()
        registerCell()
        makeSnapshot()
    }
    
    private func makeSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, MainListCoin>()
        snapshot.appendSections([0])
        snapshot.appendItems(mainListCoins, toSection: 0)
        self.snapshot = snapshot
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func setTableViewAutoLayout() {
        tableView.register(MainListTableViewCell.self, forCellReuseIdentifier: "mainListCell")
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(200)
            make.bottom.equalToSuperview()
        }
        
        tableView.estimatedRowHeight = UIFont.preferredFont(forTextStyle: .subheadline).pointSize
        + UIFont.preferredFont(forTextStyle: .caption1).pointSize
        + 30
        
    
    }
    
    private func registerCell() {
        dataSource = MainListDataSource(tableView: tableView,
                                        cellProvider: { tableView, indexPath, mainListCoin in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "mainListCell",
                                                           for: indexPath) as? MainListTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configure(mainListCoin)
            
            return cell
        })
        tableView.dataSource = dataSource
    }
}
