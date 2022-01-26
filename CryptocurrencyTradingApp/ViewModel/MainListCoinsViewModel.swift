//
//  MainListCoinsViewModel.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/25.
//

import UIKit

class MainListCoinsViewModel {
    private(set) var mainListCoins: [MainListCoin] = [] {
        didSet {
            filtered = mainListCoins.filter { existsInFiltered($0) }
            NotificationCenter.default.post(name: .restAPITickerAllNotification, object: nil)
        }
    }
    
    private(set) var filtered: [MainListCoin] = []
    private let restAPIManager = RestAPIManager()
    private let webSocketManager = WebsocketManager()
    
    var headerViewModel: MainListHeaderViewModel {
        return MainListHeaderViewModel(mainListCoinsViewModel: self)
    }
    
    func coinViewModel(at index: Int) -> MainListCoinViewModel {
        return MainListCoinViewModel(coin: filtered[index])
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
        { (parsedResult: Result<TickerAll, Error>) in
            
            switch parsedResult {
            case .success(let parsedData):
                let data = self.mirror(parsedData.data)
                    .sorted { $0.tradeValue.toDouble() > $1.tradeValue.toDouble() }
                self.filtered = data
                self.mainListCoins = data
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    private func mirror(_ data: TickerAll.Data) -> [MainListCoin] {
        let mirror = Mirror(reflecting: data)
        
        return Array(mirror.children).compactMap {
            
            guard let symbol = $0.label,
                  let coin = ($0.value as? TickerAll.Data.Coin),
                  let coinName = CoinType.name(symbol: symbol)
            else {
                return nil
            }
            
            return MainListCoin(name: coinName,
                                symbol: symbol,
                                currentPrice: coin.closingPrice,
                                fluctuationRate: coin.fluctateRate24H,
                                fluctuationAmount: coin.fluctate24H,
                                tradeValue: coin.accTradeValue24H)
        }
    }
}

// MARK: WebSocket
extension MainListCoinsViewModel {
    func initiateWebSocket() {
        webSocketManager.resume()
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
                self.updateTradeValue(ticker)
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
                mainListCoins[index].currentPrice = transaction.price
                NotificationCenter.default.post(name: .currentPriceNotification,
                                                object: nil,
                                                userInfo: ["index": index])
            }
        }
    }
    
    private func updateTradeValue(_ ticker: WebSocketTicker.Ticker) {
        mainListCoins.enumerated().forEach { index, oldCoin in
            let newSymbol = ticker.symbol.lose(from: "_")

            if mainListCoins[index].symbol == newSymbol {
                mainListCoins[index].tradeValue = ticker.accumulatedTradeValue
                NotificationCenter.default.post(name: .tradeValueNotification, object: nil)
            }
        }
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
    
    private func existsInFiltered(_ coin: MainListCoin) -> Bool {
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
