//
//  TickerViewModel.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/28.
//

import Foundation

class RestAPITickerViewModel {
    private let market: UpbitMarket
    private var mainListCoin = Ticker()
    private let networkManager = NetworkManager(networkable: NetworkModule())
    
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
        return (mainListCoin.quantity?.toDecimal().lose(from: ".") ?? .zero) + .whiteSpace + market.market.split(separator: "-")[1]
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
    
    init(_ market: UpbitMarket) {
        self.market = market
        self.initiateRestAPI()
    }

    private func initiateRestAPI() {
        let route = UpbitRoute.ticker
        networkManager.request(with: route,
                               queryItems: route.tickerQueryItems(coins: [market]),
                               requestType: .requestWithQueryItems)
        { (parsedResult: Result<[UpbitTicker], Error>) in
            
            switch parsedResult {
            case .success(let parsedData):
                let ticker = parsedData[0]
                self.mainListCoin = Ticker(openPrice: ticker.openingPrice.description,
                                           highPrice: ticker.maxiumumPrice.description,
                                           lowPrice: ticker.minimumPrice.description,
                                           prevPrice: ticker.previousClosingPrice.description,
                                           quantity: ticker.unitsTradedWithin24H.description,
                                           tradeValue: ticker.tradeValueWithin24H.description)
                NotificationCenter.default.post(name: .restAPITickerNotification, object: nil)
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
}
