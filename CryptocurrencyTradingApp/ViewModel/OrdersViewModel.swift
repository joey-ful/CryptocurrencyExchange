//
//  OrdersViewModel.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/28.
//

import Foundation

class OrdersViewModel {
    private let market: UpbitMarket
    private let networkManager = NetworkManager(networkable: NetworkModule())
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
    
    init(_ market: UpbitMarket) {
        self.market = market
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
        let route = UpbitRoute.orderbook
        networkManager.request(with: route,
                               queryItems: route.orderbookQueryItems(coins: [market]),
                               requestType: .request)
        { (parsedResult: Result<[UpbitOrderBook], Error>) in
            
            switch parsedResult {
            case .success(let parsedData):
                self.asks = parsedData[0].data.map {
                    Order(price: $0.askPrice.description,
                          quantity: $0.askSize.description)
                }.sorted { $0.price.toDouble() > $1.price.toDouble() }
                self.bids = parsedData[0].data.map {
                    Order(price: $0.bidPrice.description,
                          quantity: $0.bidSize.description)
                }.sorted { $0.price.toDouble() > $1.price.toDouble() }
                
                NotificationCenter.default.post(name: .restAPIOrderNotification, object: nil)
            case .failure(NetworkError.unverifiedCoin):
                print(NetworkError.unverifiedCoin.localizedDescription)
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
    
    func closeWebSocket() {
        webSocketManager.close()
    }
    
    private func initiateWebSocketTicker() {
        webSocketManager.connectWebSocket(to: .upbit,
                                          parameter: UpbitWebSocketParameter(ticket: webSocketManager.uuid,
                                                                             .orderbookdepth,
                                                                             [market]))
        { (parsedResult: Result<UpbitWebsocketOrderBook?, Error>) in

            switch parsedResult {
            case .success(let parsedData):
                guard let parsedData = parsedData else { return }
                
                self.asks = parsedData.data.map {
                    Order(price: $0.askPrice.description,
                          quantity: $0.askSize.description)
                }.sorted { $0.price.toDouble() > $1.price.toDouble() }
                self.bids = parsedData.data.map {
                    Order(price: $0.bidPrice.description,
                          quantity: $0.bidSize.description)
                }.sorted { $0.price.toDouble() > $1.price.toDouble() }
                
                NotificationCenter.default.post(name: .restAPIOrderNotification, object: nil)
            case .failure(NetworkError.unverifiedCoin):
                print(NetworkError.unverifiedCoin.localizedDescription)
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
}
