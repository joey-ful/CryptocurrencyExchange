//
//  PopularCoinViewModel.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/30.
//

import Foundation
import SwiftUI

class PopularCoinViewModel: ObservableObject {
    private let popularCoin: Ticker
    private let market: UpbitMarket
    private let networkManager = NetworkManager(networkable: NetworkModule())
    @Published var highPriceList: [Double]
    var lineColor: Color {
        popularCoin.fluctuationRate.contains("-") ? .blue : .red
    }
    
    init(popularCoin: Ticker, _ market: UpbitMarket) {
        self.popularCoin = popularCoin
        self.market = market
        highPriceList = []
        initializeRestAPICandle(market)
    }

    var coinName: String {
        return popularCoin.name
    }
    
    var symbol: String {
        return popularCoin.symbol.uppercased()
    }
    
    var sign: String {
        return fluctuationRate.toDouble() < 0 ? "" : "+"
    }
    
    var price: String {
        return "KRW " +  popularCoin.currentPrice.toDecimal()
    }
    
    var fluctuationRate: String {
        return popularCoin.fluctuationRate.toDecimal().setFractionDigits(to: 2) + .percent
    }
    
    var maxY: Double {
        highPriceList.max() ?? 0
    }
    
    var minY: Double {
        highPriceList.min() ?? 0
    }
    
    var yAxis: Double {
        maxY - minY
    }
}

extension PopularCoinViewModel {
    
    func initializeRestAPICandle(_ market: UpbitMarket) {
        let route = UpbitRoute.candles(.twentyFourHour)
        networkManager.request(with: route,
                               queryItems: route.candlesQueryItems(coin: market, candleCount: 24),
                               requestType: .requestWithQueryItems)
        { (parsedResult: Result<[UpbitCandleStick], Error>) in
            
            switch parsedResult {
            case .success(let parsedData):
                self.highPriceList = parsedData
                    .map { $0.highPrice }
            case .failure(NetworkError.unverifiedCoin):
                print(NetworkError.unverifiedCoin.localizedDescription)
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    private func convert(_ candleData: BithumbCandleStick.CandleStickData) -> Double {
        switch candleData {
        case .string(let result):
            return Double(result) ?? .zero
        case .integer(let date):
            return Double(date)
        }
    }
}
