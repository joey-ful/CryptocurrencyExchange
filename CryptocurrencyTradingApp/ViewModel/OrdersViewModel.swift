//
//  OrdersViewModel.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/28.
//

import Foundation

class OrdersViewModel {
    private let coinType: CoinType
    private let restAPIManager = RestAPIManager()
    private let webSocketManager = WebSocketManager()
    private var asks: [Order] = []
    private var bids: [Order] = []
    
    var orders: [Order] {
        return asks + bids
    }
    
    var middleIndex: Int {
        return asks.count - 1
    }
    
    var maxAskQuantity: Double? {
        return asks.map { $0.quantity.toDouble() }.max()
    }
    
    var maxBidQuantity: Double? {
        return bids.map { $0.quantity.toDouble() }.max()
    }
    
    func type(of order: Order) -> String {
        return asks.contains(order) ? "ask" : "bid"
    }
    
    init(coin: CoinType) {
        self.coinType = coin
        initiateRestAPI()
    }
    
    func index(of order: Order) -> Int? {
        return orders.firstIndex(of: order)
    }
    
    func orderViewModel(at index: Int) -> OrderViewModel {
        return OrderViewModel(order: orders[index], parent: self)
    }
}

extension OrdersViewModel {
    private func initiateRestAPI() {
        restAPIManager.fetch(type: .orderbook, paymentCurrency: .KRW, coin: coinType) { (parsedResult: Result<Orderbook, Error>) in
            switch parsedResult {
            case .success(let parsedData):
                self.asks = parsedData.data.asks.sorted { $0.price > $1.price }
                self.bids = parsedData.data.bids
                NotificationCenter.default.post(name: .restAPIOrderNotification, object: nil)
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
}

// MARK: WebSocket
extension OrdersViewModel {
    func initiateWebSocket() {
        initiateWebSocketTicker()
        
    }
    
    private func initiateWebSocketTicker() {
        
    }
}
