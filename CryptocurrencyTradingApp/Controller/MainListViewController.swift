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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}

extension MainListViewController {
    private func setUpTableView() {
        setTableViewAutoLayout()
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
        dataSource = MainListDataSource(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "mainListCell", for: indexPath)
                    as? MainListTableViewCell
            else {
                return UITableViewCell()
            }
            
            let coin = self.mainListCoins[indexPath.row]
            cell.configure(coin)
            
            return cell
        })
        tableView.dataSource = dataSource
    }
}
