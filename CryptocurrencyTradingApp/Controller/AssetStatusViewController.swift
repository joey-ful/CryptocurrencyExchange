//
//  AssetsStatusViewController.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/29.
//

import UIKit
import SnapKit

typealias StatusDataSource = UITableViewDiffableDataSource<Int, AssetStatus>

class AssetStatusViewController: UIViewController {
    private let viewModel: AssetStatusListViewModel
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private var dataSource: StatusDataSource?
    
    init(viewModel: AssetStatusListViewModel) {
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
                                               name: .assetStatusNotification,
                                               object: nil)
        buildUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .assetStatusNotification, object: nil)
    }
}

extension AssetStatusViewController {

    private func buildUI() {
        view.backgroundColor = .white
        buildSearchBar()
        buildSelection()
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
    
    private func buildSelection() {
        
    }
}

// MARK: SearchResultsUpdating
extension AssetStatusViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text
        viewModel.filter(text)
        makeSnapshot()
    }
}

// MARK: TableView UI
extension AssetStatusViewController {
    private func buildTableView() {
        setUpTableView()
        setTableViewAutoLayout()
        registerCell()
    }

    @objc private func makeSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, AssetStatus>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.assetStatusList, toSection: 0)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }

    private func setUpTableView() {
        tableView.register(StatusHeader.self, forHeaderFooterViewReuseIdentifier: "statusHeader")
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
        dataSource = StatusDataSource(tableView: tableView,
                                        cellProvider: { tableView, indexPath, mainListCoin in

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "statusCell",
                                                           for: indexPath) as? StatusCell else {
                return UITableViewCell()
            }

            let assetStatusViewModel = self.viewModel.assetStatusViewModel(at: indexPath.row)
            cell.configure(viewModel: assetStatusViewModel)

            return cell
        })
        tableView.dataSource = dataSource
    }
}

// MARK: TableViewHeader
extension AssetStatusViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "statusHeader")
                as? StatusHeader
        else {
            return UIView()
        }

        header.configure(viewModel.headerViewModel)

        return header
    }
}
