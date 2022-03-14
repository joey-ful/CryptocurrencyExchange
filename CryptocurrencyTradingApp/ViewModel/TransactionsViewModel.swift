//
//  TransactionsViewModel.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/25.
//

import UIKit

typealias TransactionsDataSource = UITableViewDiffableDataSource<Int, Transaction>
typealias TransactionDataSource = UITableViewDiffableDataSource<Int, Transaction>

class TransactionsViewModel {
    private(set) var transactions: [Transaction] = []
    private let market: UpbitMarket
    private let networkManager = NetworkManager(networkable: NetworkModule())
    private let webSocketManager = WebSocketManager()
    private let candleCoreDataManager = CandleCoreDataManager()
    private(set) var dayTransactions: [Transaction] = []
    private var timeCursor: String?
    private var dayLastDate: String?
    var timeDataSource: TransactionsDataSource?
    var dayDataSource: TransactionsDataSource?
    var transactionDataSource: TransactionDataSource?
    var workItem: DispatchWorkItem?

    var count: Int {
        transactions.count
    }
    
    init(_ market: UpbitMarket) {
        self.market = market
        initiateTimeRestAPI()
        initiateDayRestAPI()
    }
    
    func transactionViewModel(at index: Int) -> TransactionViewModel {
        return TransactionViewModel(transaction: transactions[index])
    }
    
    func dayTransactionViewModel(at index: Int) -> DayTransactionViewModel {
        return DayTransactionViewModel(dayTransaction: dayTransactions[index])
    }
    
    func makeTimeSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Transaction>()
        snapshot.appendSections([0])
        snapshot.appendItems(transactions, toSection: 0)
        timeDataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    func makeDaySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Transaction>()
        snapshot.appendSections([0])
        snapshot.appendItems(dayTransactions, toSection: 0)
        dayDataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    func makeTransactionSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Transaction>()
        snapshot.appendSections([0])
        let data = Array(transactions.prefix(30))
        snapshot.appendItems(data, toSection: 0)
        transactionDataSource?.apply(snapshot, animatingDifferences: false)
    }
    
}

// MARK: RestAPI Time
extension TransactionsViewModel {
    private func initiateTimeRestAPI() {
        loadRestAPITransactions()
    }
    
    
    
    private func loadRestAPITransactions() {
        let route = UpbitRoute.trades
        networkManager.request(with: route,
                               queryItems: route.tradesQueryItems(market: market,
                                                                  count: 50,
                                                                  cursor: timeCursor),
                               requestType: .request)
        { (parsedResult: Result<[UpbitTrade], Error>) in
            
            switch parsedResult {
            case .success(let parsedData):
                self.transactions += parsedData.map {
                    Transaction(symbol: nil,
                                type: $0.type.lowercased(),
                                price: $0.price.description,
                                quantity: $0.quantity.description,
                                amount: ($0.price * $0.quantity).description,
                                date: $0.timestamp.description,
                                upDown: nil)
                }.sorted { $0.date > $1.date }
                self.timeCursor = parsedData.last?.cursor.description.lose(from: ".")
            case .failure(let error):
                if error.localizedDescription != "cancelled" {
                    assertionFailure(error.localizedDescription)
                }
            }
        }
    }

    func loadMoreTimeTransactions() {
        loadRestAPITransactions()
    }
}

// MARK: RestAPI Day
extension TransactionsViewModel {
    private func initiateDayRestAPI() {
        loadRestAPICandleStick()
        loadRestAPITicker()
    }
    
    private func loadRestAPICandleStick() {
        let route = UpbitRoute.candles(.twentyFourHour)
        networkManager.request(with: route,
                               queryItems: route.candlesQueryItems(coin: market,
                                                                   lastDate: dayLastDate?.replacingOccurrences(of: "T", with: " "),
                                                                   candleCount: 50),
                               requestType: .request)
        { [weak self](parsedResult: Result<[UpbitCandleStick], Error>) in
            
            switch parsedResult {
            case .success(let parsedData):
                let candleStickData = parsedData.sorted { $0.timestamp > $1.timestamp }[1..<parsedData.endIndex]
                self?.dayTransactions += candleStickData.map {
                    Transaction(price: $0.closingPrice.description,
                                prevPrice: $0.prevPrice?.description ?? .zero,
                                quantity: $0.tradeVolume.description,
                                date: $0.dateKST.replacingOccurrences(of: "T", with: " ").dropLast(3))
                }
                self?.dayLastDate = parsedData.last?.dateKST
                self?.makeDaySnapshot()
                NotificationCenter.default.post(name: .restAPITickerNotification, object: nil)
            case .failure(NetworkError.unverifiedCoin):
                print(NetworkError.unverifiedCoin.localizedDescription)
            case .failure(let error):
                if error.localizedDescription != "cancelled" {
                    assertionFailure(error.localizedDescription)
                }
            }
        }
    }
    
    private func loadRestAPITicker() {
        let route = UpbitRoute.ticker
        networkManager.request(with: route,
                               queryItems: route.tickerQueryItems(coins: [market]),
                               requestType: .request)
        { [weak self](parsedResult: Result<[UpbitTicker], Error>) in
            
            switch parsedResult {
            case .success(let parsedData):
                let ticker = parsedData[0]
                let newTransaction = Transaction(price: ticker.closingPrice.description,
                                                 prevPrice: self?.dayTransactions.last?.price ?? "0",
                                                 quantity: ticker.unitsTraded.description,
                                                 amount: ticker.tradeValue.description,
                                                 date: ticker.date.description.toDate())

                self?.dayTransactions.append(newTransaction)
                self?.makeDaySnapshot()
            case .failure(NetworkError.unverifiedCoin):
                print(NetworkError.unverifiedCoin.localizedDescription)
            case .failure(let error):
                if error.localizedDescription != "cancelled" {
                    assertionFailure(error.localizedDescription)
                }
            }
        }
    }
    
    func loadMoreDayTransactions() {
        loadRestAPICandleStick()
    }
}
    
// MARK: WebSocket
extension TransactionsViewModel {
    func initiateTimeWebSocket() {
        
        webSocketManager.connectWebSocket(to: .upbit,
                                          parameter: UpbitWebSocketParameter(ticket: webSocketManager.uuid, .transaction, [market]))
        { [weak self] (parsedResult: Result<UpbitWebsocketTrade?, Error>) in
            
            switch parsedResult {
            case .success(let parsedData):
                guard let parsedData = parsedData else { return }
                let newTransactions = Transaction(symbol: parsedData.symbol,
                                                  type: parsedData.type.lowercased(),
                                                  price: parsedData.price.description,
                                                  quantity: parsedData.quantity.description,
                                                  amount: (parsedData.price * parsedData.quantity).description,
                                                  date: parsedData.dateTime.description,
                                                  upDown: parsedData.upDown)
                self?.transactions = ((self?.transactions ?? []) + [newTransactions]).sorted { $0.date > $1.date }
                self?.makeTimeSnapshot()
                self?.makeTransactionSnapshot()
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    func closeWebSocket() {
        webSocketManager.close()
    }
}
