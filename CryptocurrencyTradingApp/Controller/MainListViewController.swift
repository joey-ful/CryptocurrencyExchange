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
    private var mainListCoins: [MainListCoin] = [
        MainListCoin(symbol: "BTC/KRW", currentPrice: "50000000", fluctuationRate: "-1.4", fluctuationAmount: "-718000", tradeValue: "149919203251.1879", textColor: .systemBlue),
        MainListCoin(symbol: "ETH/KRW", currentPrice: "3733000", fluctuationRate: "-2.76", fluctuationAmount: "-106000", tradeValue: "111405389520.8421", textColor: .systemBlue),
        MainListCoin(symbol: "ETC/KRW", currentPrice: "40040", fluctuationRate: "6.35", fluctuationAmount: "2390", tradeValue: "361764.02901293", textColor: .systemRed)
    ]
    private var snapshot: NSDiffableDataSourceSnapshot<Int, MainListCoin>?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpTableView()
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
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
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
