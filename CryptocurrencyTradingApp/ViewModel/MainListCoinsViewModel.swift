//
//  MainListCoinsViewModel.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/25.
//

import UIKit
import Combine

typealias MainListDataSource = UITableViewDiffableDataSource<Int, Ticker>
typealias PopularDataSource = UICollectionViewDiffableDataSource<Int, Ticker>

class MainListCoinsViewModel {
    let markets: [UpbitMarket]
    var dataSource: MainListDataSource?
    var collectionViewDataSource: PopularDataSource?
    private let webSocketManager = WebSocketManager(of: .upbit)
    private let networkManager = NetworkManager(networkable: NetworkModule())
    private var subscriptions: Set<AnyCancellable> = []
    private var mainListCoins: [Ticker] = [] {
        didSet {
            filtered = mainListCoins.filter { existsInFiltered($0) }
            favorites = filtered.filter { favoriteSymbols.contains( $0.symbol.lowercased() ) }
            makeSnapshot()
        }
    }
    private(set) var favorites: [Ticker] = []
    private(set) var filtered: [Ticker] = []
    @Published private(set) var updatedCellInfo: (Int?, Int?, Bool) = (nil, nil, false)
    var showFavorites: Bool = false
    
    private var favoriteSymbols: [String] {
        return UserDefaults.standard.array(forKey: "favorite") as? [String] ?? []
    }
    
    var popularCoins: [Ticker] {
        return Array(
            mainListCoins
                .sorted { $0.tradeValue.toDouble() > $1.tradeValue.toDouble() }
                .prefix(10)
        )
    }
    
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
        let symbol = popularCoins[index].symbol
        let market = markets.filter { $0.market.contains(symbol.uppercased()) }[0]
        return PopularCoinViewModel(popularCoin: popularCoins[index], market)
    }
    
    private func makeCollectionViewSnapshot() {
       var snapshot = NSDiffableDataSourceSnapshot<Int, Ticker>()
       snapshot.appendSections([0])
       snapshot.appendItems(popularCoins, toSection: 0)
       collectionViewDataSource?.apply(snapshot, animatingDifferences: false)
   }
    
    @objc func makeSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Ticker>()
        snapshot.appendSections([0])
        let data = showFavorites ? favorites : filtered
        snapshot.appendItems(data, toSection: 0)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    init(_ markets: [UpbitMarket]) {
        self.markets = markets
        initiateRestAPI()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(makeSnapshot),
                                               name: .updateSortNotification,
                                               object: nil)
    }
}

// MARK: RestAPI
extension MainListCoinsViewModel {
    
    func initiateRestAPI() {
        
        let route = UpbitRoute.ticker
        networkManager.dataTaskPublisher(with: route,
                                         queryItems: route.tickerQueryItems(coins: markets),
                                         requestType: .request)
            .map { [weak self] (tickers: [UpbitTicker]) -> [Ticker] in
                guard let self = self else { return [] }
                return tickers.map {
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
            }
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    assertionFailure(error.localizedDescription)
                }
            } receiveValue: { [weak self] data in
                guard let self = self else { return }
                self.filtered = data
                self.mainListCoins = data
                self.makeSnapshot()
                self.makeCollectionViewSnapshot()
            }
            .store(in: &subscriptions)
    }
}

// MARK: WebSocket
extension MainListCoinsViewModel {
    func initiateWebSocket(to exchange: WebSocketURL) {
        initiateTransactionWebSocket(to: exchange)
        initiateTickerWebSocket(to: exchange)
    }
    
    private func initiateTransactionWebSocket(to exchange: WebSocketURL) {
        URLSession.shared.webSocketPublisher(exchange,
                                             UpbitWebSocketParameter(ticket: UUID(),
                                                                     .transaction,
                                                                     markets))
            .decode(type: UpbitWebsocketTrade.self, decoder: JSONDecoder())
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    assertionFailure(error.localizedDescription)
                }
            } receiveValue: { data in
                self.updateTransaction(data)
            }
            .store(in: &subscriptions)
    }
    
    func closeWebSocket() {
        webSocketManager.close()
    }
    
    private func initiateTickerWebSocket(to exchange: WebSocketURL) {
        URLSession.shared.webSocketPublisher(exchange, UpbitWebSocketParameter(ticket: UUID(),
                                                                               .ticker,
                                                                               markets))
            .decode(type: UpbitWebsocketTicker.self, decoder: JSONDecoder())
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    assertionFailure(error.localizedDescription)
                }
            } receiveValue: { data in
                self.updateTradeValueAndFluctuations(data)
            }
            .store(in: &subscriptions)
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
                filtered = mainListCoins.filter { existsInFiltered($0) }
                favorites = filtered.filter { favoriteSymbols.contains( $0.symbol.lowercased() ) }
                updateIndices(at: index, hasRisen: newPrice.toDouble() > oldPrice.toDouble())
                
                guard let item = dataSource?.itemIdentifier(for: IndexPath(row: index, section: 0)) else { return }
                guard var snapShot = dataSource?.snapshot() else { return }
                snapShot.reconfigureItems([item])
                dataSource?.apply(snapShot, animatingDifferences:  true)
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
                filtered = mainListCoins.filter { existsInFiltered($0) }
                favorites = filtered.filter { favoriteSymbols.contains( $0.symbol.lowercased() ) }
            }
        }
    }
    
    private func updateIndices(at index: Int, hasRisen: Bool = true) {
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
        
        updatedCellInfo = (filteredIndex, favoritesIndex, hasRisen)
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
