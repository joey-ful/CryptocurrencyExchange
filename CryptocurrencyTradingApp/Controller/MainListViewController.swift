//
//  MainListViewController.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/20.
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
        
        view.backgroundColor = .white
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(initializeMainList),
                                               name: .restAPITickerAllNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateCoin),
                                               name: .webSocketTickerNotification,
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
        buildTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        webSocketManager.resume()
        webSocketManager.connectWebSocket(.transaction, CoinType.allCoins, nil)
        webSocketManager.connectWebSocket(.ticker, CoinType.allCoins, [.twentyfour, .yesterday])
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
    
    @objc private func updateCoin(notification: Notification) {
        guard let ticker = notification.userInfo?["data"] as? Ticker else { return }
        
        DispatchQueue.main.async { [weak self] in
            self?.mainListCoins.enumerated().forEach { index, oldCoin in
                if self?.mainListCoins[index].symbol == ticker.symbol.replacingOccurrences(of: "_", with: "/") {
                    
                    let sign = ticker.fluctuationRate.contains("-") ? "" : "+"
                    self?.mainListCoins[index].fluctuationRate = sign + ticker.fluctuationRate.toDecimal() + .percent
                    self?.mainListCoins[index].fluctuationAmount = sign + ticker.fluctuationAmount.toDecimal()
                    self?.mainListCoins[index].textColor = sign == "+" ? .systemRed : .systemBlue
                    self?.makeSnapshot()
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
    private func buildTableView() {
        setUpTableView()
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
    
    private func setUpTableView() {
        tableView.register(MainListTableViewCell.self, forCellReuseIdentifier: "mainListCell")
        tableView.register(MainListHeaderView.self, forHeaderFooterViewReuseIdentifier: "mainListHeader")
        tableView.delegate = self
    }
    
    private func setTableViewAutoLayout() {
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

extension MainListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chartViewController = ChartViewController()
        let coinName = mainListCoins[indexPath.row].symbol.split(separator: "/")[0].lowercased()
        guard let coin = CoinType.coin(coinName: coinName) else { return }
        webSocketManager.close()
        chartViewController.initiate(paymentCurrency: .KRW, coin: coin)
        navigationController?.pushViewController(chartViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "mainListHeader")
                as? MainListHeaderView
        else {
            return UIView()
        }
        
        header.configure(sortName: sortName,
                         sortPrice: sortPrice,
                         sortFluctuation: sortFluctuation,
                         sortTradeValue: sortTradeValue)
        
        return header
    }
    
    private func sortName(type: Sort) {
        switch type {
        case .up:
            mainListCoins.sort { $0.name < $1.name }
        case .down:
            mainListCoins.sort { $0.name > $1.name }
        case .none:
            break
        }
    }
    
    private func sortPrice(type: Sort) {
        switch type {
        case .up:
            mainListCoins.sort { $0.currentPrice.toDouble() < $1.currentPrice.toDouble() }
        case .down:
            mainListCoins.sort { $0.currentPrice.toDouble() > $1.currentPrice.toDouble() }
        case .none:
            break
        }
    }
    
    private func sortFluctuation(type: Sort) {
        switch type {
        case .up:
            mainListCoins.sort { $0.fluctuationRate.toDouble() < $1.fluctuationRate.toDouble() }
        case .down:
            mainListCoins.sort { $0.fluctuationRate.toDouble() > $1.fluctuationRate.toDouble() }
        case .none:
            break
        }
    }
    
    private func sortTradeValue(type: Sort) {
        switch type {
        case .up:
            mainListCoins.sort { $0.tradeValue.toDouble() < $1.tradeValue.toDouble() }
        case .down:
            mainListCoins.sort { $0.tradeValue.toDouble() > $1.tradeValue.toDouble() }
        case .none:
            break
        }
    }
}
