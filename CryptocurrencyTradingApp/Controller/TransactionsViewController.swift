//
//  TransactionsViewController.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/25.
//

import UIKit

typealias TransactionsDataSource = UITableViewDiffableDataSource<Int, Transaction>

class TransactionsViewController: UIViewController {
    private var viewModel: TransactionsViewModel
    private let coinType: CoinType
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private var dataSource: TransactionsDataSource?
    
    init(coin: CoinType) {
        self.viewModel = TransactionsViewModel(coinType: coin)
        coinType = coin
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(makeSnapshot),
                                               name: .restAPITransactionsNotification,
                                               object: nil)
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.initiateWebSocket()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(makeSnapshot),
                                               name: .webSocketTransactionsNotification,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .webSocketTransactionsNotification, object: nil)
    }
}

extension TransactionsViewController {

    @objc private func makeSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Transaction>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.transactions, toSection: 0)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func configureTableView() {
        setUpTableView()
        setTableViewAutoLayout()
        createDataSource()
    }
    
    private func setUpTableView() {
        tableView.register(TransactionsTableViewCell.self, forCellReuseIdentifier: "transactionsCell")
        tableView.register(TransactionsTableViewTimeHeader.self, forHeaderFooterViewReuseIdentifier: "transactionsTimeHeader")
    }
    
    private func setTableViewAutoLayout() {
        view.addSubview(tableView)
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.estimatedRowHeight = UIFont.preferredFont(forTextStyle: .subheadline).pointSize + 30
    }

    private func createDataSource() {
        dataSource = TransactionsDataSource(tableView: tableView,
                                            cellProvider: { tableView, indexPath, itemIdentifier in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "transactionsCell") as? TransactionsTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configure(viewModel: self.viewModel.transactionViewModel(at: indexPath.row))
            
            return cell
        })

        tableView.dataSource = dataSource
    }
}

extension TransactionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "transactionsTimeHeader") as? TransactionsTableViewTimeHeader else { return UITableViewHeaderFooterView() }
        
        header.configure()
        
        return header
    }
}
