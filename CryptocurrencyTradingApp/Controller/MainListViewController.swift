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
    private let viewModel: MainListCoinsViewModel
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private var dataSource: MainListDataSource?
    
    init(viewModel: MainListCoinsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(makeSnapshot),
                                               name: .restAPITickerAllNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(makeSnapshot),
                                               name: .tradeValueNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateDataSource),
                                               name: .currentPriceNotification,
                                               object: nil)
        
        buildUI()
    }

    override func viewWillAppear(_ animated: Bool) {
//        viewModel.initiateWebSocket()
    }

    override func viewWillDisappear(_ animated: Bool) {
        viewModel.closeWebSocket()
    }
}

// MARK: Handle Notification
extension MainListViewController {
    @objc private func updateDataSource(notification: Notification) {
        guard let userInfo = notification.userInfo, let index = userInfo["index"] as? Int else { return }
        let cell = (tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? MainListTableViewCell)
        cell?.blink(viewModel.coinViewModel(at: index))
        makeSnapshot()
    }
}

// MARK: SearchBar
extension MainListViewController {

    private func buildUI() {
        view.backgroundColor = .white
        buildSearchBar()
        buildTableView()
    }

    private func buildSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "코인명 또는 심볼 검색"
        searchController.searchBar.searchTextField.font = .preferredFont(forTextStyle: .subheadline)
        searchController.searchBar.searchTextField.backgroundColor = .white
        searchController.searchBar.autocapitalizationType = .none
        definesPresentationContext = true
    }
}

// MARK: SearchResultsUpdating
extension MainListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text
        viewModel.filter(text)
        makeSnapshot()
    }
}

// MARK: TableView UI
extension MainListViewController {
    private func buildTableView() {
        setUpTableView()
        setTableViewAutoLayout()
        registerCell()
    }

    @objc private func makeSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, MainListCoin>()
        snapshot.appendSections([0])
        print(viewModel.filtered)
        snapshot.appendItems(viewModel.filtered, toSection: 0)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }

    private func setUpTableView() {
        tableView.register(MainListTableViewCell.self, forCellReuseIdentifier: "mainListCell")
        tableView.register(MainListHeaderView.self, forHeaderFooterViewReuseIdentifier: "mainListHeader")
        tableView.delegate = self
    }

    private func setTableViewAutoLayout() {
        view.addSubview(tableView)
        tableView.backgroundColor = .white
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
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

            let mainListCoinViewModel = self.viewModel.coinViewModel(at: indexPath.row)
            cell.configure(mainListCoinViewModel)

            return cell
        })
        tableView.dataSource = dataSource
    }
}

// MARK: TableViewHeader
extension MainListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let chartViewController = ChartViewController()
        
        let mainListCoinViewModel = self.viewModel.coinViewModel(at: indexPath.row)
        guard let coin = mainListCoinViewModel.coinType else { return }
        viewModel.closeWebSocket()
//        chartViewController.initiate(paymentCurrency: .KRW, coin: coin)
//        navigationController?.pushViewController(chartViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "mainListHeader")
                as? MainListHeaderView
        else {
            return UIView()
        }

        header.configure(viewModel.headerViewModel)

        return header
    }
}
