//
//  TransactionsViewController.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/25.
//

import UIKit
import SnapKit

typealias TransactionsDataSource = UITableViewDiffableDataSource<Int, Transaction>

class TransactionsViewController: UIViewController {
    private var viewModel: TransactionsViewModel
    private let coinType: CoinType
    private let timeTableView = UITableView(frame: .zero, style: .grouped)
    private let dayTableView = UITableView(frame: .zero, style: .grouped)
    private var timeDataSource: TransactionsDataSource?
    private var dayDataSource: TransactionsDataSource?
    lazy var menuControl: UISegmentedControl = {
        let menuControl = UISegmentedControl(items: ["시간별", "일별"])
        menuControl.selectedSegmentIndex = 0
        menuControl.layer.borderColor = UIColor.gray.cgColor
        menuControl.addTarget(self, action: #selector(menuSelect), for: .valueChanged)
        menuControl.layer.masksToBounds = true
        return menuControl
    }()
    

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
                                               selector: #selector(makeTimeSnapshot),
                                               name: .restAPITransactionsNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(makeDaySnapshot),
                                               name: .candlestickNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(makeDaySnapshot),
                                               name: .restAPITickerNotification,
                                               object: nil)
        menuControlAutolayout()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.initiateTimeWebSocket()
        getWebSocketNotification()
    }
    
    private func getWebSocketNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(makeTimeSnapshot),
                                               name: .webSocketTransactionsNotification,
                                               object: nil)
    }
    
    private func removeWebSocketNotification() {
        NotificationCenter.default.removeObserver(self,
                                                  name: .webSocketTransactionsNotification,
                                                  object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: .restAPITransactionsNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: .webSocketTransactionsNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: .candlestickNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: .restAPITickerNotification,
                                                  object: nil)
    }
}

extension TransactionsViewController {
    private func menuControlAutolayout() {
        view.addSubview(menuControl)
        menuControl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(view.safeAreaLayoutGuide.snp.height).multipliedBy(0.05)
        }
    }

    @objc func menuSelect(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            timeTableView.isHidden = false
            dayTableView.isHidden = true
            getWebSocketNotification()
            makeTimeSnapshot()
        case 1:
            timeTableView.isHidden = true
            dayTableView.isHidden = false
            removeWebSocketNotification()
            makeDaySnapshot()
        default:
            break
        }
    }
}

extension TransactionsViewController {

    @objc private func makeTimeSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Transaction>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.transactions, toSection: 0)
        timeDataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    @objc private func makeDaySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Transaction>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.dayTransactions, toSection: 0)
        dayDataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func configureTableView() {
        setUpTableView(type: "timeTransactions", tableView: timeTableView)
        setUpTableView(type: "dayTransactions", tableView: dayTableView)
        setTableViewAutoLayout(of: timeTableView)
        setTableViewAutoLayout(of: dayTableView)
        timeDataSource = createDataSource(isTime: true)
        timeTableView.dataSource = timeDataSource
        dayDataSource = createDataSource(isTime: false)
        dayTableView.dataSource = dayDataSource
        dayTableView.isHidden = true
    }
    
    private func setUpTableView(type: String, tableView: UITableView) {
        tableView.register(TransactionsCell.self,
                           forCellReuseIdentifier: "\(type)Cell")
        tableView.register(TransactionsHeader.self,
                           forHeaderFooterViewReuseIdentifier: "\(type)Header")
    }
    
    private func setTableViewAutoLayout(of tableView: UITableView) {
        view.addSubview(tableView)
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.snp.makeConstraints { make in
            make.top.equalTo(menuControl.snp.bottom).offset(10)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(view.safeAreaLayoutGuide.snp.height).multipliedBy(0.60)
        }
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.estimatedRowHeight = UIFont.preferredFont(forTextStyle: .subheadline).pointSize + 30
    }
    
    private func createDataSource(isTime: Bool) -> TransactionDataSource {
        return TransactionsDataSource(tableView: isTime ? self.timeTableView : self.dayTableView,
                                                cellProvider: { [weak self] tableView, indexPath, itemIdentifier in
            
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: isTime ? "timeTransactionsCell" : "dayTransactionsCell") as? TransactionsCell
            else { return UITableViewCell() }
            
            if isTime {
                guard let transactionViewModel = self?.viewModel.transactionViewModel(at: indexPath.row)
                else { return UITableViewCell() }
                cell.configure(isTimeCell: isTime, viewModel: transactionViewModel)
            } else {
                guard let dayTransactionViewModel = self?.viewModel.dayTransactionViewModel(at: indexPath.row)
                else { return UITableViewCell() }
                cell.configure(isTimeCell: isTime, viewModel: dayTransactionViewModel)
            }
            
            return cell
        })
    }
}

extension TransactionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var identifier = ""
        var isTime = true
        if tableView == timeTableView {
            identifier = "timeTransactionsHeader"
        } else if tableView == dayTableView {
            identifier = "dayTransactionsHeader"
            isTime = false
        }

        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier)
                as? TransactionsHeader
        else { return UITableViewHeaderFooterView() }
        
        header.configure(isTimeCell: isTime, symbol: coinType.symbol)
        
        return header
    }
}
