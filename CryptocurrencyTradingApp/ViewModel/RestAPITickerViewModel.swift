//
//  TickerViewModel.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/28.
//

import Foundation

class RestAPITickerViewModel {
    private let coin: CoinType
    private var mainListCoin = Ticker()
    private let restAPIManager = RestAPIManager()
    
    var infoList: [(title: String, value: String)] {
        return [
            ("거래량", quantity),
            ("거래금", tradeValue),
            ("separator", "separator"),
            ("전일종가", prevPrice),
            ("시가(당일)", openPrice),
            ("고가(당일)", highPrice),
            ("저가(당일)", lowPrice)
        ]
    }
    
    var infoListCount: Int {
        infoList.count
    }
    
    func valueType(at index: Int) -> String {
        if infoList[index].title.contains("고가") {
            return "high"
        } else if infoList[index].title.contains("저가") {
            return "low"
        }
        return "default"
    }
    
    private var quantity: String {
        return (mainListCoin.quantity?.setFractionDigits(to: 3) ?? .zero) + .whiteSpace + coin.symbol
    }
    
    private var tradeValue: String {
        return mainListCoin.tradeValue.dividedByHundredMillion() + .whiteSpace + .tenMillion
    }
    
    private var prevPrice: String {
        return mainListCoin.prevPrice?.toDecimal() ?? .zero
    }
    
    private var openPrice: String {
        return mainListCoin.openPrice?.toDecimal() ?? .zero
    }
    
    private var highPrice: String {
        
        return mainListCoin.highPrice?.toDecimal() ?? .zero
    }
    
    private var lowPrice: String {
        return mainListCoin.lowPrice?.toDecimal() ?? .zero
    }
    
    init(coin: CoinType) {
        self.coin = coin
        self.initiateRestAPI(coin)
    }

    private func initiateRestAPI(_ coin: CoinType) {
        restAPIManager.fetch(type: .ticker,
                             paymentCurrency: .KRW,
                             coin: coin) { (parsedResult: Result<RestAPITicker, Error>) in
            
            switch parsedResult {
            case .success(let parsedData):
                let ticker = parsedData.data
                self.mainListCoin = Ticker(openPrice: ticker.openingPrice,
                                                 highPrice: ticker.maxiumumPrice,
                                                 lowPrice: ticker.minimumPrice,
                                                 prevPrice: ticker.previousClosingPrice,
                                                 quantity: ticker.unitsTradedWithin24H,
                                                 tradeValue: ticker.tradeValueWithin24H)
                NotificationCenter.default.post(name: .restAPITickerNotification, object: nil)
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
}
