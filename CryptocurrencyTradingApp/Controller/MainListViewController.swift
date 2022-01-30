//
//  MainListViewController.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/20.
//

import UIKit
import SnapKit

typealias MainListDataSource = UITableViewDiffableDataSource<Int, Ticker>
typealias PopularDataSource = UICollectionViewDiffableDataSource<Int, Ticker>

class MainListViewController: UIViewController {
    private let viewModel: MainListCoinsViewModel
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private var dataSource: MainListDataSource?
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var collectionViewDataSource: PopularDataSource?

    
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
                                               selector: #selector(makeAllSnapshots),
                                               name: .restAPITickerAllNotification,
                                               object: nil)
        buildUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel.initiateWebSocket()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(makeSnapshot),
                                               name: .webSocketTicker24HNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(makeAllSnapshots),
                                               name: .webSocketTransactionsNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(makeAllSnapshots),
                                               name: .webSocketTickerNotification,
                                               object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .webSocketTicker24HNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .webSocketTransactionsNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: .webSocketTickerNotification, object: nil)
    }
    
    deinit {
        viewModel.closeWebSocket()
    }
}

// MARK: Handle Notification
extension MainListViewController {
    @objc private func updateDataSource(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let index = userInfo["index"] as? Int else { return }
        
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

// MARK: TableView CollectionView
extension MainListViewController {
    private func buildTableView() {
        setUpTableView()
        setAutoLayout()
        registerCell()
        registerCollectionViewCell()
        setCollectionViweFlowLayout()
    }
    
    @objc private func makeAllSnapshots() {
        makeSnapshot()
        makeCollectionViewSnapshot()
    }

    @objc private func makeSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Ticker>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.filtered, toSection: 0)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    @objc private func makeCollectionViewSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Ticker>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.popularCoins, toSection: 0)
        collectionViewDataSource?.apply(snapshot, animatingDifferences: false)
    }

    private func setUpTableView() {
        tableView.register(MainListTableViewCell.self, forCellReuseIdentifier: "mainListCell")
        tableView.register(MainListHeaderView.self, forHeaderFooterViewReuseIdentifier: "mainListHeader")
        tableView.delegate = self
    }
    
    private func setCollectionViweFlowLayout() {
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
        collectionView.delegate = self
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.minimumLineSpacing = 20
//        let inset: CGFloat = 20
//        layout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
//        let height = view.bounds.height * 0.2 - inset * 2
//        let width = height * 9 / 10
//        layout.itemSize = CGSize(width: width, height: height)
//        collectionView.collectionViewLayout = layout
    }

    // MARK: AutoLayout
    private func setAutoLayout() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemGray6
        view.addSubview(tableView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.2)
        }
        
        tableView.backgroundColor = .white
        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
//            make.height.equalToSuperview().multipliedBy(0.6)
        }

        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.estimatedRowHeight = UIFont.preferredFont(forTextStyle: .subheadline).pointSize
        + UIFont.preferredFont(forTextStyle: .caption1).pointSize
        + 30
    }

    // MARK: CellRegistrations
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
    
    private func registerCollectionViewCell() {
        let cellRegistration = UICollectionView.CellRegistration
        <PopularCoinCell, Ticker> { cell, indexPath, popularCoin in
            
            cell.configure(self.viewModel.popularCoinViewModel(at: indexPath.item), parent: self)
        }
        
        collectionViewDataSource = PopularDataSource(collectionView: collectionView)
        { collectionView, indexPath, popularCoin in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: popularCoin)
        }
        collectionView.dataSource = collectionViewDataSource
    }
}

// MARK: TableViewHeader
extension MainListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let childVC = AssetStatusViewController(viewModel: AssetStatusListViewModel())
        navigationController?.pushViewController(childVC, animated: true)
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

extension MainListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height - 20 * 2
        let width = height * 9 / 10
        return CGSize(width: width, height: height)
    }
}
