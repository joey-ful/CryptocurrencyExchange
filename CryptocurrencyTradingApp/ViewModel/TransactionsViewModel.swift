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
    private let webSocketManager = WebsocketManager()
    
    var count: Int {
        transactions.count
    }
    
    init(coinType: CoinType) {
        self.coinType = coinType
        initiateWithRestAPI()
        updateWithWebSocket(coinType)
    }
    
    func transactionViewModel(at index: Int) -> TransactionViewModel {
        return TransactionViewModel(transaction: transactions[index])
    }
    
    private func initiateWithRestAPI() {
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
    
    private func updateWithWebSocket(_ coinType: CoinType) {
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
}
