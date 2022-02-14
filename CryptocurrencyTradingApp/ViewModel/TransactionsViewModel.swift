//
//  TransactionsViewModel.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/25.
//

import UIKit

class TransactionsViewModel {
    private(set) var transactions: [Transaction] = [] {
        didSet {
            NotificationCenter.default.post(name: .restAPITransactionsNotification, object: nil)
        }
    }
    private let market: UpbitMarket
    private let networkManager = NetworkManager(networkable: NetworkModule())
    private let webSocketManager = WebSocketManager()
    private let candleCoreDataManager = CandleCoreDataManager()
    private(set) var dayTransactions: [Transaction] = []
    
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
}

// MARK: RestAPI Time
extension TransactionsViewModel {
    private func initiateTimeRestAPI() {
        initiateRestAPITransactionHistory()
    }
    
    private func initiateRestAPITransactionHistory() {
        let route = UpbitRoute.trades
        networkManager.request(with: route,
                               queryItems: route.tradesQueryItems(market: market, count: 60),
                               requestType: .requestWithQueryItems)
        { (parsedResult: Result<[UpbitTrade], Error>) in
            
            switch parsedResult {
            case .success(let parsedData):
                self.transactions = parsedData.map {
                    Transaction(symbol: nil,
                                type: $0.type.lowercased(),
                                price: $0.price.description,
                                quantity: $0.quantity.description,
                                amount: ($0.price * $0.quantity).description,
                                date: $0.date.description,
                                upDown: nil)
                }.sorted { $0.date > $1.date }
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
}

// MARK: RestAPI Day
extension TransactionsViewModel {
    private func initiateDayRestAPI() {
        initiateRestAPICandleStick()
        initiateRestAPITicker()
    }
    
    private func initiateRestAPICandleStick() {
        let route = UpbitRoute.candles(.twentyFourHour)
        networkManager.request(with: route,
                               queryItems: route.candlesQueryItems(coin: market, candleCount: 100),
                               requestType: .requestWithQueryItems)
        { (parsedResult: Result<[UpbitCandleStick], Error>) in
            
            switch parsedResult {
            case .success(let parsedData):
                self.dayTransactions = parsedData.map {
                    Transaction(price: $0.closingPrice.description,
                                prevPrice: $0.prevPrice?.description ?? .zero,
                                quantity: $0.tradeVolume.description,
                                date: $0.date.description)
                }.sorted { $0.date > $1.date }
                NotificationCenter.default.post(name: .candlestickNotification, object: nil)
            case .failure(NetworkError.unverifiedCoin):
                print(NetworkError.unverifiedCoin.localizedDescription)
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    private func initiateRestAPITicker() {
        let route = UpbitRoute.ticker
        networkManager.request(with: route,
                               queryItems: route.tickerQueryItems(coins: [market]),
                               requestType: .requestWithQueryItems)
        { (parsedResult: Result<[UpbitTicker], Error>) in
            
            switch parsedResult {
            case .success(let parsedData):
                let ticker = parsedData[0]
                let newTransaction = Transaction(price: ticker.closingPrice.description,
                                                 prevPrice: self.dayTransactions.last?.price ?? "0",
                                                 quantity: ticker.unitsTraded.description,
                                                 amount: ticker.tradeValue.description,
                                                 date: ticker.date.description.toDate())
                self.dayTransactions.append(newTransaction)
                NotificationCenter.default.post(name: .restAPITickerNotification, object: nil)
            case .failure(NetworkError.unverifiedCoin):
                print(NetworkError.unverifiedCoin.localizedDescription)
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
}
    
// MARK: WebSocket
extension TransactionsViewModel {
    func initiateTimeWebSocket() {
//        webSocketManager.createWebSocket(of: .bithumb)
//        webSocketManager.connectWebSocket(parameter: BithumbWebSocketParameter(.transaction, [coinType], nil)) { (parsedResult: Result<BithumbWebSocketTransaction?, Error>) in
//
//            switch parsedResult {
//            case .success(let parsedData):
//                guard let parsedData = parsedData else { return }
//                let newTransactions = parsedData.content.list.map {
//                    Transaction(symbol: $0.symbol,
//                                type: $0.type,
//                                price: $0.price,
//                                quantity: $0.quantity,
//                                amount: $0.amount,
//                                date: $0.dateTime,
//                                upDown: $0.upDown)
//                }
//                self.transactions = (self.transactions + newTransactions).sorted { $0.date > $1.date }
//                NotificationCenter.default.post(name: .webSocketTransactionsNotification,
//            case .failure(let error):
//                assertionFailure(error.localizedDescription)
//            }
//        }
    }
    
    func closeWebSocket() {
        webSocketManager.close()
    }
}
