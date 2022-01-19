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
        MainListCoin(name: "비트코인", symbol: "BTC/KRW", currentPrice: "50,000,000", fluctuationRate: "-1.40%", fluctuationAmount: "-718,000", tradeValue: "82,587백만", textColor: .systemBlue),
        MainListCoin(name: "이더리움", symbol: "ETH/KRW", currentPrice: "3,733,000", fluctuationRate: "-2.76%", fluctuationAmount: "-106,000", tradeValue: "111,405백만", textColor: .systemBlue),
        MainListCoin(name: "이더리움 클래식", symbol: "ETC/KRW", currentPrice: "0.00000338", fluctuationRate: "16.35%", fluctuationAmount: "420,000", tradeValue: "3백만", textColor: .systemRed)
    ]
    private let mainListHeaders = ["가산자산명", "현재가", "변동률", "거래금액"]
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
