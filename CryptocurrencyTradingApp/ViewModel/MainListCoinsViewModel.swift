//
//  MainListCoinsViewModel.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/25.
//

import UIKit

class MainListCoinsViewModel {
    private var mainListCoins: [Ticker] = [] {
        didSet {
            filtered = mainListCoins.filter { existsInFiltered($0) }
            favorites = filtered.filter { favoriteSymbols.contains( $0.symbol.lowercased() ) }
        }
    }
    
    private var favoriteSymbols: [String] {
        return UserDefaults.standard.array(forKey: "favorite") as? [String] ?? []
    }
    
    private(set) var favorites: [Ticker] = []
    
    private(set) var filtered: [Ticker] = []
    var popularCoins: [Ticker] {
        return Array(
            mainListCoins
                .sorted { $0.tradeValue.toDouble() > $1.tradeValue.toDouble() }
                .prefix(10)
        )
    }
    private let restAPIManager = RestAPIManager()
    private let webSocketManager = WebSocketManager()
    
    var headerViewModel: MainListHeaderViewModel {
        return MainListHeaderViewModel(mainListCoinsViewModel: self)
    }
    
    func coinViewModel(at index: Int) -> MainListCoinViewModel {
        return MainListCoinViewModel(coin: filtered[index])
    }
    
    func favoriteCoinViewModel(at index: Int) -> MainListCoinViewModel {
        return MainListCoinViewModel(coin: favorites[index])
    }
    
    func popularCoinViewModel(at index: Int) -> PopularCoinViewModel {
        return PopularCoinViewModel(popularCoin: popularCoins[index])
    }
    
    init() {
        initiateRestAPI()
    }
}

// MARK: RestAPI
extension MainListCoinsViewModel {
    
    private func initiateRestAPI() {
        restAPIManager.fetch(type: .tickerAll,
                             paymentCurrency: .KRW)
        { (parsedResult: Result<RestAPITickerAll, Error>) in
            
            switch parsedResult {
            case .success(let parsedData):
                let data = parsedData.data.compactMap { key, value -> Ticker? in
                    if case let .coin(coin) = value {
                        return Ticker(name: CoinType.coin(symbol: key)?.name ?? "-",
                                      symbol: key.lowercased(),
                                      currentPrice: coin.closingPrice,
                                      fluctuationRate: coin.fluctateRate24H,
                                      fluctuationAmount: coin.fluctate24H,
                                      tradeValue: coin.accTradeValue24H)
                    } else {
                        return nil
                    }
                }.sorted { $0.tradeValue.toDouble() > $1.tradeValue.toDouble() }    
                self.filtered = data
                self.mainListCoins = data
                NotificationCenter.default.post(name: .restAPITickerAllNotification, object: nil)
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
}

// MARK: WebSocket
extension MainListCoinsViewModel {
    func initiateWebSocket() {
        webSocketManager.createWebSocket()
        initiateTransactionWebSocket()
        initiateTickerWebSocket()
    }
    
    func closeWebSocket() {
        webSocketManager.close()
    }
    
    private func initiateTransactionWebSocket() {
        webSocketManager.connectWebSocket(.transaction,
                                          CoinType.allCoins,
                                          nil)
        { (parsedResult: Result<WebSocketTransaction?, Error>) in
            
            switch parsedResult {
            case .success(let parsedData):
                guard let transactions = parsedData?.content.list else { return }
                transactions.forEach { self.updateTransaction($0) }
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    private func initiateTickerWebSocket() {
        webSocketManager.connectWebSocket(.ticker,
                                          CoinType.allCoins,
                                          [.twentyfour, .yesterday])
        { (parsedResult: Result<WebSocketTicker?, Error>) in
            
            switch parsedResult {
            case .success(let parsedData):
                guard let ticker = parsedData?.content else { return }
                if ticker.tickType == "24H" {
                    self.updateTradeValue(ticker)
                } else if ticker.tickType == "MID" {
                    self.updateFluctuationAndUnisTraded(ticker)
                }
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    private func updateTransaction(_ transaction: WebSocketTransaction.Transaction) {
        mainListCoins.enumerated().forEach { index, oldCoin in
            let newSymbol = transaction.symbol.lose(from: "_").lowercased()

            if mainListCoins[index].symbol == newSymbol
            {
                let oldPrice = mainListCoins[index].currentPrice
                let newPrice = transaction.price
                if newPrice == oldPrice { return }
                
                mainListCoins[index].currentPrice = newPrice
                let userInfo = userInfo(at: index)
                NotificationCenter.default.post(name: .webSocketTransactionsNotification,
                                                object: "currentPrice",
                                                userInfo: userInfo)
            }
        }
    }
    
    private func updateTradeValue(_ ticker: WebSocketTicker.Ticker) {
        mainListCoins.enumerated().forEach { index, oldCoin in
            let newSymbol = ticker.symbol.lose(from: "_").lowercased()
            
            if mainListCoins[index].symbol == newSymbol {
                mainListCoins[index].tradeValue = ticker.accumulatedTradeValue
                let userInfo = userInfo(at: index)
                NotificationCenter.default.post(name: .webSocketTicker24HNotification,
                                                object: "tradeValue",
                                                userInfo: userInfo)
            }
        }
    }
    
    private func updateFluctuationAndUnisTraded(_ ticker: WebSocketTicker.Ticker) {
        mainListCoins.enumerated().forEach { index, oldCoin in
            let newSymbol = ticker.symbol.lose(from: "_").lowercased()
            
            if mainListCoins[index].symbol == newSymbol {
                mainListCoins[index].fluctuationRate = ticker.fluctuationRate
                mainListCoins[index].fluctuationAmount = ticker.fluctuationAmount
                
                let userInfo = userInfo(at: index)
                NotificationCenter.default.post(name: .webSocketTickerNotification,
                                                object: "fluctuation",
                                                userInfo: userInfo)
            }
        }
    }
    
    private func userInfo(at index: Int) -> [String: Int?] {
        var filteredIndex: Int? = nil
        filtered.enumerated().forEach { currentIndex, coin in
            if mainListCoins[index] == coin {
                filteredIndex = currentIndex
                return
            }
        }
        var favoritesIndex: Int? = nil
        favorites.enumerated().forEach { currentIndex, coin in
            if mainListCoins[index] == coin {
                favoritesIndex = currentIndex
                return
            }
        }
        return ["filtered": filteredIndex, "favorites": favoritesIndex]
    }
}


// MARK: SearchBar
extension MainListCoinsViewModel {
    
    func filter(_ target: String?) {
        let text = target?.lowercased() ?? ""

        if text == "" {
            filtered = mainListCoins
        } else {
            filtered = mainListCoins.filter { return $0.name.contains(text) || $0.symbol.contains(text) }
        }
    }
    
    private func existsInFiltered(_ coin: Ticker) -> Bool {
        for filteredCoin in filtered {
            if filteredCoin.symbol == coin.symbol {
                return true
            }
        }
        return false
    }
}

// MARK: Sorts
extension MainListCoinsViewModel {
    func sortName(type: Sort) {
        switch type {
        case .up:
            mainListCoins.sort { $0.name < $1.name }
        case .down:
            mainListCoins.sort { $0.name > $1.name }
        case .none:
            break
        }
    }

    func sortPrice(type: Sort) {
        switch type {
        case .up:
            mainListCoins.sort { $0.currentPrice.toDouble() < $1.currentPrice.toDouble() }
        case .down:
            mainListCoins.sort { $0.currentPrice.toDouble() > $1.currentPrice.toDouble() }
        case .none:
            break
        }
    }

    func sortFluctuation(type: Sort) {
        switch type {
        case .up:
            mainListCoins.sort { $0.fluctuationRate.toDouble() < $1.fluctuationRate.toDouble() }
        case .down:
            mainListCoins.sort { $0.fluctuationRate.toDouble() > $1.fluctuationRate.toDouble() }
        case .none:
            break
        }
    }

    func sortTradeValue(type: Sort) {
        switch type {
        case .up:
            mainListCoins.sort { $0.tradeValue.toDouble() < $1.tradeValue.toDouble() }
        case .down:
            mainListCoins.sort { $0.tradeValue.toDouble() > $1.tradeValue.toDouble() }
        case .none:
            break
        }
    }
}
