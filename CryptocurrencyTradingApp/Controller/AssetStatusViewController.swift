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
    private let searchBar = UISearchBar(frame: .zero)
    
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
        view.addSubview(searchBar)
        searchBar.delegate = self
        searchBar.placeholder = "코인명 또는 심볼 검색"
        searchBar.searchTextField.font = .preferredFont(forTextStyle: .subheadline)
        searchBar.searchTextField.backgroundColor = .white
        searchBar.autocapitalizationType = .none
        definesPresentationContext = true
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        searchBar.layer.borderColor = UIColor.systemGray.cgColor
        searchBar.layer.borderWidth = 0.5
        searchBar.layer.cornerRadius = 4
    }
    
    private func buildSelection() {
        
    }
}

// MARK: SearchResultsUpdating
extension AssetStatusViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchBar.text
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
        snapshot.appendItems(viewModel.filtered, toSection: 0)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }

    private func setUpTableView() {
        tableView.delegate = self
        tableView.register(StatusCell.self, forCellReuseIdentifier: "statusCell")
        tableView.register(StatusHeader.self, forHeaderFooterViewReuseIdentifier: "statusHeader")
    }

    private func setTableViewAutoLayout() {
        view.addSubview(tableView)
        tableView.backgroundColor = .white
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
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

        header.configure()

        return header
    }
}
