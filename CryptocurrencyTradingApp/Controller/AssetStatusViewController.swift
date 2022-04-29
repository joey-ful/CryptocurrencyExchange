//
//  AssetsStatusViewController.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/29.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxRelay

class AssetStatusViewController: UIViewController {
    private let viewModel: AssetStatusListViewModel
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let searchBar = UISearchBar(frame: .zero)
    var disposeBag = DisposeBag()
    
    init(viewModel: AssetStatusListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildUI()
    }
    
}

extension AssetStatusViewController {
    
    private func buildUI() {
        view.backgroundColor = .white
        buildSearchBar()
        searchResultUpdating()
        buildTableView()
    }
    
    private func buildSearchBar() {
        view.addSubview(searchBar)
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
    
    private func searchResultUpdating() {
        _ = searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: {
                self.viewModel.searchResult(query: $0)
            })

    }
}

// MARK: TableView UI
extension AssetStatusViewController {
    private func buildTableView() {
        setUpTableView()
        setTableViewAutoLayout()
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.register(StatusCell.self, forCellReuseIdentifier: "statusCell")
        tableView.register(StatusHeader.self, forHeaderFooterViewReuseIdentifier: "statusHeader")
        
        viewModel.filterdObservable
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: "statusCell", cellType: StatusCell.self)) {
                index, item, cell in
                cell.configure(with: item)
            }
            .disposed(by: disposeBag)
    }
    
    
    private func setTableViewAutoLayout() {
        view.addSubview(tableView)
        tableView.backgroundColor = .white
        tableView.sectionHeaderHeight = UIFont.preferredFont(forTextStyle: .caption1).pointSize + 20
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
