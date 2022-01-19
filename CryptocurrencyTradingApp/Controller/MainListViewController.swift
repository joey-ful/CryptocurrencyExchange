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

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(initializeMainList), name: .restAPITickerAllNotification, object: nil)
        restAPIManager.fetch(type: .tickerAll, paymentCurrency: .KRW)
        setUpTableView()
    }

}

extension MainListViewController {
    @objc private func initializeMainList(notification: Notification) {
        if let data = notification.userInfo?["data"] as? [MainListCoin] {
            mainListCoins = data
            makeSnapshot()
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
        dataSource?.apply(snapshot)
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
