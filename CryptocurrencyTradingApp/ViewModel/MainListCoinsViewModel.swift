//
//  MainListCoinsViewModel.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/25.
//

import UIKit

class MainListCoinsViewModel {
    private let markets: [UpbitMarket]
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
    private let webSocketManager = WebSocketManager(of: .upbit)
    private let networkManager = NetworkManager(networkable: NetworkModule())
    
    var headerViewModel: MainListHeaderViewModel {
        return MainListHeaderViewModel(mainListCoinsViewModel: self)
    }
    
    func coinViewModel(at index: Int, hasRisen: Bool = true) -> MainListCoinViewModel {
        return MainListCoinViewModel(coin: filtered[index], hasRisen: hasRisen)
    }
    
    func favoriteCoinViewModel(at index: Int) -> MainListCoinViewModel {
        return MainListCoinViewModel(coin: favorites[index])
    }
    
    func popularCoinViewModel(at index: Int) -> PopularCoinViewModel {
        return PopularCoinViewModel(popularCoin: popularCoins[index])
    }
    
    init(_ markets: [UpbitMarket]) {
        self.markets = markets
        initiateRestAPI()
    }
}

// MARK: RestAPI
extension MainListCoinsViewModel {
    
    private func initiateRestAPI() {
        
        let route = UpbitRoute.ticker
        networkManager.request(with: route,
                               queryItems: route.tickerQueryItems(coins: markets),
                               requestType: .requestWithQueryItems)
        { (parsedResult: Result<[UpbitTicker], Error>) in
            
            switch parsedResult {
            case .success(let tickers):
                let data: [Ticker] = tickers.map {
                    let symbol = $0.market.split(separator: "-")[1]
                    let market = self.markets.filter { $0.market.contains(symbol) }[0]
                    let fluctuationRate = ($0.fluctuationRate24HDividedByHundred * 100).description
                    
                    return Ticker(name: market.koreanName,
                                  symbol: symbol.lowercased(),
                                  currentPrice: $0.closingPrice.description,
                                  fluctuationRate: fluctuationRate,
                                  fluctuationAmount: $0.fluctuation24H.description,
                                  tradeValue: $0.tradeValueWithin24H.description)
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
    func initiateWebSocket(to exchange: WebSocketURL) {
        initiateTransactionWebSocket(to: exchange)
        initiateTickerWebSocket(to: exchange)
    }
    
    func closeWebSocket() {
        webSocketManager.close()
    }
    
    private func initiateTransactionWebSocket(to exchange: WebSocketURL) {
        webSocketManager.connectWebSocket(to: exchange,
                                          parameter: UpbitWebSocketParameter(ticket: UUID(),
                                                                             .transaction,
                                                                             markets))
        { (parsedResult: Result<UpbitWebsocketTrade?, Error>) in
            
            switch parsedResult {
            case .success(let parsedData):
                self.updateTransaction(parsedData)
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    private func initiateTickerWebSocket(to exchange: WebSocketURL) {
        webSocketManager.connectWebSocket(to: exchange,
                                          parameter: UpbitWebSocketParameter(ticket: webSocketManager.uuid,
                                                                             .ticker,
                                                                             markets))
        { (parsedResult: Result<UpbitWebsocketTicker?, Error>) in

            switch parsedResult {
            case .success(let parsedData):
                self.updateTradeValueAndFluctuations(parsedData)
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    private func updateTransaction(_ transaction: UpbitWebsocketTrade?) {
        guard let transaction = transaction else { return }

        mainListCoins.enumerated().forEach { index, oldCoin in
            let newSymbol = transaction.market.split(separator: "-")[1].lowercased()

            if mainListCoins[index].symbol == newSymbol
            {
                
                let oldPrice = mainListCoins[index].currentPrice
                let newPrice = transaction.price.description
                if newPrice == oldPrice { return }
                
                mainListCoins[index].currentPrice = newPrice
                let userInfo = userInfo(at: index, hasRisen: newPrice.toDouble() > oldPrice.toDouble())
                NotificationCenter.default.post(name: .webSocketTransactionsNotification,
                                                object: "currentPrice",
                                                userInfo: userInfo)
            }
        }
    }
    
    private func updateTradeValueAndFluctuations(_ ticker: UpbitWebsocketTicker?) {
        guard let ticker = ticker else { return }
        
        mainListCoins.enumerated().forEach { index, oldCoin in
            let newSymbol = ticker.market.split(separator: "-")[1].lowercased()
            
            if mainListCoins[index].symbol == newSymbol {
                
                mainListCoins[index].tradeValue = ticker.accumulatedTradeValue.description
                mainListCoins[index].fluctuationRate = (ticker.fluctuationRate * 100).description
                mainListCoins[index].fluctuationAmount = ticker.fluctuationAmount.description
            }
        }
    }
    
    private func userInfo(at index: Int, hasRisen: Bool = true) -> [String: Any] {
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
        return ["filtered": filteredIndex, "favorites": favoritesIndex, "hasRisen": hasRisen]
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
