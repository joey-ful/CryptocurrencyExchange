//
//  TransactionsViewController.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/25.
//

import UIKit
import SnapKit

class TransactionsViewController: UIViewController {
    private var viewModel: TransactionsViewModel
    private let market: UpbitMarket
    private let timeTableView = UITableView(frame: .zero, style: .grouped)
    private let dayTableView = UITableView(frame: .zero, style: .grouped)
    lazy var menuControl: UISegmentedControl = {
        let menuControl = UISegmentedControl(items: ["시간별", "일별"])
        menuControl.selectedSegmentIndex = 0
        menuControl.layer.borderColor = UIColor.gray.cgColor
        menuControl.addTarget(self, action: #selector(menuSelect), for: .valueChanged)
        menuControl.layer.masksToBounds = true
        return menuControl
    }()
    

    init(_ market: UpbitMarket) {
        self.market = market
        self.viewModel = TransactionsViewModel(market)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuControlAutolayout()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.initiateTimeWebSocket()
    }

    override func viewWillDisappear(_ animated: Bool) {
        viewModel.closeWebSocket()
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
            viewModel.makeTimeSnapshot()
        case 1:
            timeTableView.isHidden = true
            dayTableView.isHidden = false
            viewModel.makeDaySnapshot()
        default:
            break
        }
    }
}

extension TransactionsViewController {

    private func configureTableView() {
        setUpTableView(type: "timeTransactions", tableView: timeTableView)
        setUpTableView(type: "dayTransactions", tableView: dayTableView)
        setTableViewAutoLayout(of: timeTableView)
        setTableViewAutoLayout(of: dayTableView)
        viewModel.timeDataSource = createDataSource(isTime: true)
        timeTableView.dataSource = viewModel.timeDataSource
        viewModel.dayDataSource = createDataSource(isTime: false)
        dayTableView.dataSource = viewModel.dayDataSource
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
        tableView.sectionHeaderHeight = UIFont.preferredFont(forTextStyle: .callout).pointSize + 20
        tableView.snp.makeConstraints { make in
            make.top.equalTo(menuControl.snp.bottom).offset(10)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
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
        
        header.configure(isTimeCell: isTime, symbol: market.symbol)
        
        return header
    }
}
