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
    private let coin: CoinType
    private let restAPIManager = RestAPIManager()
    @Published var highPriceList: [Double]
    var lineColor: Color {
        popularCoin.fluctuationRate.contains("-") ? .blue : .red
    }
    
    init(popularCoin: Ticker) {
        self.popularCoin = popularCoin
        self.coin = CoinType.coin(symbol: popularCoin.symbol) ?? .unverified
        highPriceList = []
        initializeRestAPICandle(coin: coin)
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
    
    func initializeRestAPICandle(coin: CoinType) {
        restAPIManager.fetch(type: .candlestick,
                             paymentCurrency: .KRW,
                             coin: coin,
                             chartIntervals: .oneHour) { (parsedResult: Result<BithumbCandleStick, Error>) in
            
            switch parsedResult {
            case .success(let parsedData):
                
                let data = Array(parsedData.data.suffix(24))
                self.highPriceList = data
                    .map { self.convert($0[3])}
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
