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
    private var asks: [Order] = []
    private var bids: [Order] = []
    
    var orders: [Order] {
        return asks + bids
    }
    
    var maxAskQuantity: Double? {
        return asks.max { $0.quantity.toDouble() < $1.quantity.toDouble() }?.quantity.toDouble()
    }
    
    var maxBidQuantity: Double? {
        return bids.max { $0.quantity.toDouble() < $1.quantity.toDouble() }?.quantity.toDouble()
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
                self.asks = parsedData.data.asks
                self.bids = parsedData.data.bids
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
}
