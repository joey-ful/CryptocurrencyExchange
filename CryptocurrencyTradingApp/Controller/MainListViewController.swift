//
//  MainListViewController.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/20.
//

import UIKit
import SnapKit
import RxSwift

class MainListViewController: UIViewController {
    private let viewModel: MainListCoinsViewModel
    private let tableView = UITableView(frame: .zero, style: .plain)
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
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
    private var disposeBag = DisposeBag()
    
    init(viewModel: MainListCoinsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCellBlink()
        buildUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.initiateWebSocket(to: .upbit)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.closeWebSocket()
    }
}

// MARK: Handle cell blink
extension MainListViewController {
    private func setUpCellBlink() {
        viewModel.indexObservable
            .asDriver(onErrorJustReturn: UpdatedInfo())
            .drive(onNext: { [weak self] updateInfo in
                guard let self = self, let cell = (self.tableView.cellForRow(at: IndexPath(row: updateInfo.index, section: 0)) as? MainListCell) else { return }
                if self.tableView.visibleCells.contains(cell) {
                    cell.blink(updateInfo.hasRisen)
                }
            })
            .disposed(by: disposeBag)
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
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "코인명 또는 심볼 검색"
        searchController.searchBar.searchTextField.font = .preferredFont(forTextStyle: .subheadline)
        searchController.searchBar.searchTextField.backgroundColor = .white
        searchController.searchBar.autocapitalizationType = .none
        definesPresentationContext = true
        
        
        let _ = searchController.searchBar.rx.text.orEmpty
            .subscribe(onNext: { [weak self] in
                self?.viewModel.searchResult(query: $0)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: SegmentedControl
extension MainListViewController {
    @objc func menuSelect(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            viewModel.showFavoriteObesrvable.accept(false)
        case 1:
            viewModel.showFavoriteObesrvable.accept(true)
        default:
            break
        }
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
    
    private func setUpTableView() {
        tableView.register(MainListCell.self, forCellReuseIdentifier: "mainListCell")
        tableView.register(MainListHeader.self, forHeaderFooterViewReuseIdentifier: "mainListHeader")
        collectionView.register(PopularCoinCell.self, forCellWithReuseIdentifier: "popularCell")
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
            make.height.equalToSuperview().multipliedBy(0.19)
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
    
    private func registerCell() {
        Observable.combineLatest(viewModel.showFavoriteObesrvable, viewModel.filterdObservable) { [weak self] (showFavorites, filtered) in 
            guard let self = self else { return [] }
            let favorites = self.viewModel.favoriteObesrvable.value
            return showFavorites ? favorites : filtered
        }
        .asDriver(onErrorJustReturn: [])
        .drive(tableView.rx.items(cellIdentifier: "mainListCell", cellType: MainListCell.self)) {
            index, item, cell in
            cell.configure(item, self.viewModel)
        }
        .disposed(by: disposeBag)
    }
    
    
    private func registerCollectionViewCell() {
        viewModel.popularObservable
            .asDriver(onErrorJustReturn: [])
            .drive(collectionView.rx.items(cellIdentifier: "popularCell", cellType: PopularCoinCell.self)) {
                [weak self] index, item, cell in
                if let viewModel = self?.viewModel.popularCoinViewModel(at: index), let parent = self {
                    cell.configure(viewModel, parent: parent)
                }
            }.disposed(by: disposeBag)
    }
}

// MARK: TableViewHeader
extension MainListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let list = viewModel.showFavoriteObesrvable.value ? viewModel.favoriteObesrvable.value : viewModel.filterdObservable.value
        let coin = CoinType.coin(symbol: list[indexPath.row].symbol.lowercased()) ?? .unverified
        let symbol = list[indexPath.row].symbol.uppercased()
        let market = viewModel.markets.filter { $0.market.contains(symbol) }[0]
        let detailViewController = DetailCoinViewController(market: market)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "mainListHeader")
                as? MainListHeader
        else {
            return UIView()
        }
        header.configure(viewModel)
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
