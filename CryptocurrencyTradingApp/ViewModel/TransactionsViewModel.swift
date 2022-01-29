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
    private let coinType: CoinType
    private let restAPIManager = RestAPIManager()
    private let webSocketManager = WebSocketManager()
    private let candleCoreDataManager = CandleCoreDataManager()
    private(set) var dayTransactions: [Transaction] = []
    
    var count: Int {
        transactions.count
    }
    
    init(coinType: CoinType, isTime: Bool) {
        self.coinType = coinType
        isTime ? initiateTimeRestAPI() : initiateDayRestAPI()
    }
    
    func transactionViewModel(at index: Int) -> TransactionViewModel {
        return TransactionViewModel(transaction: transactions[index])
    }
    
    func dayTransactionViewModel(at index: Int) -> DayTransactionViewModel {
        return DayTransactionViewModel(dayTransaction: dayTransactions[index])
    }
    
    func readDayTransactions() -> [Transaction] {
        guard let candleData = candleCoreDataManager.read(entityName: .twentyFourHour, coin: coinType)
                as? [CandleData24H] else { return [] }
        
        return candleData.enumerated().map { index, data in
            let prevPrice = (index == 0 ? candleData[0].closePrice : candleData[index - 1].closePrice)
            return Transaction(price: data.closePrice.description,
                               prevPrice: prevPrice.description,
                               amount: data.tradeVolume.description,
                               date: data.date)
        }.sorted { $0.date > $1.date }
    }
    
}

// MARK: RestAPI
extension TransactionsViewModel {
    private func initiateDayRestAPI() {
        initiateRestAPICandleStick()
        initiateRestAPITicker()
    }
    
    private func initiateTimeRestAPI() {
        initiateRestAPITransactionHistory()
    }
    
    private func initiateRestAPITransactionHistory() {
        restAPIManager.fetch(type: .transactionHistory,
                             paymentCurrency: .KRW,
                             coin: coinType) { (parsedResult: Result<RestAPITransaction, Error>) in

            guard case .success(let parsedData) = parsedResult else { return }
            self.transactions = parsedData.data.map {
                Transaction(symbol: nil,
                            type: $0.type,
                            price: $0.price,
                            quantity: $0.quantity,
                            amount: $0.amount,
                            date: $0.date,
                            upDown: nil)
            }.sorted { $0.date > $1.date }
        }
    }
    
    private func initiateRestAPICandleStick() {
        restAPIManager.fetch(type: .candlestick, paymentCurrency: .KRW, coin: coinType, chartIntervals: .twentyFourHour) { (parsedResult: Result<CandleStick, Error>) in
            switch parsedResult {
            case .success(let parsedData):
                self.convertCandleToTransaction(parsedData.data)
                NotificationCenter.default.post(name: .candlestickNotification, object: nil)
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    private func convertCandleToTransaction(_ candleData: [[CandleStick.CandleStickData]]) {
        dayTransactions = candleData.enumerated().map { index, candle in
            let price: Double = convert(candle[2])
            let prevPrice: Double = index == 0
            ? convert(candle[2])
            : convert(candleData[index - 1][2])
            let quantity: Double = convert(candle[5])
            let date: String = convert(candle[0])
            
            return Transaction(price: price.description,
                               prevPrice: prevPrice.description,
                               quantity: quantity.description,
                               date: date)
        }.sorted { $0.date > $1.date }
    }
    
    private func convert(_ candleData: CandleStick.CandleStickData) -> Double {
        switch candleData {
        case .string(let result):
            return Double(result) ?? .zero
        case .integer(let date):
            return Double(date)
        }
    }
    
    private func convert(_ candleData: CandleStick.CandleStickData) -> String {
        switch candleData {
        case .string(let result):
            return String(result)
        case .integer(let date):
            return String(date)
        }
    }
    
    private func initiateRestAPITicker() {
        restAPIManager.fetch(type: .ticker,
                             paymentCurrency: .KRW,
                             coin: coinType) { (parsedResult: Result<RestAPITicker, Error>) in
            
            guard case .success(let parsedData) = parsedResult else { return }
            let ticker = parsedData.data
            let newTransaction = Transaction(price: ticker.closingPrice,
                                             prevPrice: self.dayTransactions.last?.price ?? "0",
                                             quantity: ticker.unitsTraded,
                                             amount: ticker.tradeValue,
                                             date: ticker.date.toDate())
            self.dayTransactions.append(newTransaction)
            NotificationCenter.default.post(name: .restAPITickerNotification, object: nil)
        }
    }
}
    
// MARK: WebSocket
extension TransactionsViewModel {
    func initiateTimeWebSocket() {
        webSocketManager.createWebSocket()
        webSocketManager.connectWebSocket(.transaction,
                                          [coinType],
                                          nil) { (parsedResult: Result<WebSocketTransaction?, Error>) in
            
            switch parsedResult {
            case .success(let parsedData):
                guard let parsedData = parsedData else { return }
                let newTransactions = parsedData.content.list.map {
                    Transaction(symbol: $0.symbol,
                                type: $0.type,
                                price: $0.price,
                                quantity: $0.quantity,
                                amount: $0.amount,
                                date: $0.dateTime,
                                upDown: $0.upDown)
                }
                self.transactions = (self.transactions + newTransactions).sorted { $0.date > $1.date }
                NotificationCenter.default.post(name: .webSocketTransactionsNotification,
                                                object: nil)
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    func closeWebSocket() {
        webSocketManager.close()
    }
}
