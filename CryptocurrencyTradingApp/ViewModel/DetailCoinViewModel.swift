//
//  DetailViewModel.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/01/30.
//

import Foundation

class DetailCoinViewModel {
    private let restAPIManager = RestAPIManager()
    private let webSocketManager = WebSocketManager()
    
    var coin: CoinType?
    var coinInfomation: DetailCoinModel? = DetailCoinModel(status: "", data: DetailCoinModel.CoinData(openingPrice: "", closingPrice: "", minPrice: "", maxPrice: "", unitsTraded: "", accTradeValue: "", prevClosingPrice: "", unitsTraded24H: "", accTradeValue24H: "", fluctate24H: "", fluctateRate24H: "", date: "")) {
        didSet(newData) {
            NotificationCenter.default.post(name: .coinDetailNotificaion, object: ["detailCoin": newData])
        }
    }
    
    init(coin: CoinType) {
        self.coin = coin
        initiateViewModel()
//        repeatData(coin: coin)
    }
    
    func initiateViewModel () {
        restAPIManager.fetch(type: .ticker, paymentCurrency: .KRW, coin: coin) { [weak self]  (parsedResult: Result<DetailCoinModel, Error>) in
            switch parsedResult {
            case .success(let parsedData):
                self?.coinInfomation = parsedData
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
//
//    func repeatData(coin: CoinType) {
//
//        webSocketManager.connectWebSocket(.ticker, [coin], nil) { [weak self] (parsedResult: Result<DetailCoinModel?, Error>) in
//            switch parsedResult {
//            case.success(let data):
//                print(data?.data.openingPrice)
//                NotificationCenter.default.post(name: .coinChartWebSocketReceiveNotificaion, object: ["detailCoin": data])
//
//            case.failure(let error):
//                print(error.localizedDescription)
//            }
////            guard case .success(let parsedData) = parsedResult else {
////
////                return
////            }
////            print(parsedData)
////            self?.coinInfomation = parsedData
////            NotificationCenter.default.post(name: .coinChartWebSocketReceiveNotificaion, object: ["detailCoin": parsedData])
//
//        }
//    }
}
