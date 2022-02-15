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
                               requestType: .request)
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
                               requestType: .request)
        { (parsedResult: Result<[UpbitCandleStick], Error>) in
            
            switch parsedResult {
            case .success(let parsedData):
                self.dayTransactions = parsedData.map {
                    Transaction(price: $0.closingPrice.description,
                                prevPrice: $0.prevPrice?.description ?? .zero,
                                quantity: $0.tradeVolume.description,
                                date: $0.timestamp.description)
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
                               requestType: .request)
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
        
        webSocketManager.connectWebSocket(to: .upbit,
                                          parameter: UpbitWebSocketParameter(ticket: webSocketManager.uuid, .transaction, [market]))
        { (parsedResult: Result<UpbitWebsocketTrade?, Error>) in
            
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
                self.transactions = (self.transactions + [newTransactions]).sorted { $0.date > $1.date }
                NotificationCenter.default.post(name: .webSocketTransactionsNotification, object: nil)
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    func closeWebSocket() {
        webSocketManager.close()
    }
}
