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
    private let tableView = UITableView(frame: .zero, style: .plain)
    private var dataSource: MainListDataSource?
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var collectionViewDataSource: PopularDataSource?
    private let collectionViewHeaderTop = UIView()
    private let collectionViewHeaderLeading = UIView()
    private let collectionViewHeader = UILabel.makeLabel(font: .subheadline, text: "인기 코인")
    private lazy var collectionViewHeaderStackView = UIStackView.makeStackView(alignment: .leading,
                                                                               subviews: [collectionViewHeaderLeading,
                                                                                          collectionViewHeader])
    private let topInset: CGFloat = 5
    private let bottomInset: CGFloat = 15
    lazy var menuControl: UISegmentedControl = {
        let menuControl = UISegmentedControl(items: ["전체", "관심"])
        menuControl.selectedSegmentIndex = 0
        menuControl.layer.borderColor = UIColor.gray.cgColor
        menuControl.addTarget(self, action: #selector(menuSelect), for: .valueChanged)
        menuControl.layer.masksToBounds = true
        return menuControl
    }()
    private var showFavorites: Bool = false

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
                                               selector: #selector(updateDataSource),
                                               name: .webSocketTransactionsNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(makeSnapshot),
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
        NotificationCenter.default.removeObserver(self, name: .restAPITickerAllNotification, object: nil)
    }
}

// MARK: Handle Notification
extension MainListViewController {
    @objc private func updateDataSource(notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any] else { return }
        guard let targetIndex = (showFavorites ? userInfo["favorites"] : userInfo["filtered"]) as? Int else { return }
        
        let cell = (tableView.cellForRow(at: IndexPath(row: targetIndex, section: 0)) as? MainListCell)
        cell?.blink(viewModel.coinViewModel(at: targetIndex))
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

// MARK: SegmentedControl
extension MainListViewController {
    @objc func menuSelect(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            showFavorites = false
        case 1:
            showFavorites = true
        default:
            break
        }
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
        let data = showFavorites ? viewModel.favorites : viewModel.filtered
        snapshot.appendItems(data, toSection: 0)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    @objc private func makeCollectionViewSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Ticker>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.popularCoins, toSection: 0)
        collectionViewDataSource?.apply(snapshot, animatingDifferences: false)
    }

    private func setUpTableView() {
        tableView.register(MainListCell.self, forCellReuseIdentifier: "mainListCell")
        tableView.register(MainListHeader.self, forHeaderFooterViewReuseIdentifier: "mainListHeader")
        tableView.delegate = self
    }
    
    private func setCollectionViweFlowLayout() {
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
        collectionView.delegate = self
    }

    // MARK: AutoLayout
    private func setAutoLayout() {
        view.addSubview(collectionViewHeaderTop)
        view.addSubview(collectionViewHeaderStackView)
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemGray6
        view.addSubview(menuControl)
        view.addSubview(tableView)
        
        collectionViewHeaderTop.backgroundColor = .systemGray6
        collectionViewHeaderTop.snp.makeConstraints { make in
            make.width.equalTo(collectionViewHeaderStackView)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(10)
        }
        
        collectionViewHeaderStackView.backgroundColor = .systemGray6
        collectionViewHeaderStackView.snp.makeConstraints { make in
            make.top.equalTo(collectionViewHeaderTop.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        collectionViewHeaderLeading.backgroundColor = .systemGray6
        collectionViewHeaderLeading.snp.makeConstraints {
            $0.width.equalTo(20)
            $0.height.equalTo(collectionViewHeader).multipliedBy(1.1)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(collectionViewHeaderStackView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.17)
        }
        
        menuControl.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.04)
        }
        
        tableView.backgroundColor = .white
        tableView.snp.makeConstraints { make in
            make.top.equalTo(menuControl.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.estimatedRowHeight = UIFont.preferredFont(forTextStyle: .subheadline).pointSize
        + UIFont.preferredFont(forTextStyle: .caption1).pointSize
        + 30
    }

    // MARK: CellRegistrations
    private func registerCell() {
        dataSource = MainListDataSource(tableView: tableView,
                                        cellProvider: { [weak self ] tableView, indexPath, mainListCoin in

            guard let weakSelf = self else { return UITableViewCell() }
            
            let viewModel = weakSelf.showFavorites ? weakSelf.viewModel.favoriteCoinViewModel(at: indexPath.row) : weakSelf.viewModel.coinViewModel(at: indexPath.row)
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "mainListCell",
                                                           for: indexPath) as? MainListCell
            else {
                return UITableViewCell()
            }
            
            cell.configure(viewModel)

            return cell
        })
        tableView.dataSource = dataSource
    }
    
    private func registerCollectionViewCell() {
        let cellRegistration = UICollectionView.CellRegistration
        <PopularCoinCell, Ticker> { [weak self] cell, indexPath, popularCoin in
            
            if let viewModel = self?.viewModel.popularCoinViewModel(at: indexPath.item),
               let parent = self {
                cell.configure(viewModel, parent: parent)
            }
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
        let list = showFavorites ? viewModel.favorites : viewModel.filtered
        let coin = CoinType.coin(symbol: list[indexPath.row].symbol.lowercased()) ?? .btc
        let detailViewController = DetailCoinViewController(coin: coin)
        navigationController?.pushViewController(detailViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "mainListHeader")
                as? MainListHeader
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
        return UIEdgeInsets(top: topInset, left: bottomInset, bottom: bottomInset, right: bottomInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height - topInset - bottomInset
        let width = height * 9 / 10
        return CGSize(width: width, height: height)
    }
}
