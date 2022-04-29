//
//  MainListCoinsViewModel.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay


final class MainListCoinsViewModel {
    private var mainListConinsObservable = BehaviorRelay<[Ticker]>(value: [])
    var filterdObservable = BehaviorRelay<[Ticker]>(value: [])
    var popularObservable = BehaviorRelay<[Ticker]>(value: [])
    var nameSortObesrvable = BehaviorRelay<Sort>(value: .none)
    var priceSortObesrvable = BehaviorRelay<Sort>(value: .none)
    var fluctuationSortObesrvable = BehaviorRelay<Sort>(value: .none)
    var tradeValueSortObesrvable = BehaviorRelay<Sort>(value: .none)
    var showFavoriteObesrvable = BehaviorRelay<Bool>(value: false)
    var favoriteObesrvable = BehaviorRelay<[Ticker]>(value: [])
    var indexObservable = BehaviorRelay<UpdatedInfo>(value: UpdatedInfo())
    private var disPoseBag = DisposeBag()
    let markets: [UpbitMarket]
    private var favoriteSymbols: [String] {
        return UserDefaults.standard.array(forKey: "favorite") as? [String] ?? []
    }
    private let webSocketManager = WebSocketManager(of: .upbit)
    private let networkManager = NetworkManager(networkable: NetworkModule())
    
    func popularCoinViewModel(at index: Int) -> PopularCoinViewModel {
        let coin = popularObservable.value[index]
        let symbol = coin.symbol
        let market = markets.filter { $0.market.contains(symbol.uppercased()) }[0]
        return PopularCoinViewModel(popularCoin: coin, market)
    }
    
    private func bindFilterdObservable() {
        mainListConinsObservable.map { [weak self] in
            guard let self = self else { return []}
            return $0.filter { 
                self.existsInFiltered($0)
            }
        }.bind(to:filterdObservable)
            .disposed(by: disPoseBag)
        
    }
    
    private func bindFavoriteObesrvable() {
        filterdObservable.map { [weak self] in 
            guard let self = self else { return []}
            return $0.filter { self.favoriteSymbols.contains($0.symbol)}
        }.bind(to: favoriteObesrvable)
            .disposed(by: disPoseBag)
        
    }
    
    init(_ markets: [UpbitMarket]) {
        self.markets = markets
        bindFilterdObservable()
        bindFavoriteObesrvable()
        initAPI()
    }
}

// MARK: RestAPI
extension MainListCoinsViewModel {
    private func initAPI() {
        let route = UpbitRoute.ticker
        let requestBuilder = URLRequestBuilder.request
        guard let request = requestBuilder.buildRequest(route: route, queryItems: route.tickerQueryItems(coins: markets), header: nil, bodyParameters: nil, httpMethod: .get) else { return }
        _ = RXnetworkManager().download(request: request)
            .map { (data: [UpbitTicker]) in
                data.map { ticker -> Ticker in
                    let symbol = ticker.market.split(separator: "-")[1]
                    let market = self.markets.filter { $0.market.contains(symbol) }[0]
                    let fluctuationRate = (ticker.fluctuationRate24HDividedByHundred * 100).description
                    return Ticker(name: market.koreanName,
                                  symbol: symbol.lowercased(),
                                  currentPrice: ticker.closingPrice.description,
                                  fluctuationRate: fluctuationRate,
                                  fluctuationAmount: ticker.fluctuation24H.description,
                                  tradeValue: ticker.tradeValueWithin24H.description)
                }.sorted { $0.tradeValue.toDouble() > $1.tradeValue.toDouble() }
            }.take(1)
            .subscribe(onNext: { [weak self] in
                self?.mainListConinsObservable.accept($0)
                self?.filterdObservable.accept($0)
                self?.popularObservable.accept(Array($0.prefix(10)))
            })
            .disposed(by: disPoseBag)
    }
}

// MARK: WebSocket
extension MainListCoinsViewModel {
    func initiateWebSocket(to exchange: WebSocketURL) {
        initiateTickerWebSocketRX(to: exchange)
    }
    
    func closeWebSocket() {
        webSocketManager.close()
    }
    
    private func initiateTickerWebSocketRX(to exchange: WebSocketURL) {
        
        let a = webSocketManager.connectWebsocketRX(to: exchange,
                                                    parameter: UpbitWebSocketParameter(ticket: webSocketManager.uuid,
                                                                                       .ticker,
                                                                                       markets))
            .debounce(.microseconds(400), scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .compactMap{ [weak self] (websocket: UpbitWebsocketTicker?) in
                self?.mainListConinsObservable.value.enumerated().map { currentIndex, data -> Ticker in
                    if data.symbol == websocket?.market.split(separator: "-")[1].lowercased(), data.currentPrice != websocket?.tradePrice.description {
                        self?.findRecentlyUpdatedIndex(currentIndex, hasRisen: data.currentPrice.toDouble() < websocket?.tradePrice ?? .zero)
                        return Ticker(name: data.name, symbol: data.symbol, currentPrice: websocket?.tradePrice.description ?? .zero,
                                      fluctuationRate: ((websocket?.fluctuationRate ?? .zero) * 100).description
                                      , fluctuationAmount: websocket?.fluctuationAmount.description ?? .zero, tradeValue: data.tradeValue)
                    }
                    return data
                }
            }
            .bind(to: mainListConinsObservable)
            .disposed(by: disPoseBag)
    }
    
    private func findRecentlyUpdatedIndex(_ index: Int, hasRisen: Bool = true) {
        switch showFavoriteObesrvable.value {
        case true: 
            favoriteObesrvable.value.enumerated().forEach { currentIndex, coin in
                if mainListConinsObservable.value[index] == coin {
                    indexObservable.accept(UpdatedInfo(index: currentIndex, hasRisen: hasRisen))
                    return
                }
            }
        case false:
            filterdObservable.value.enumerated().forEach { currentIndex, coin in
                if mainListConinsObservable.value[index] == coin {
                    indexObservable.accept(UpdatedInfo(index: currentIndex, hasRisen: hasRisen))
                    return
                }
            }
        }
    }
}

// MARK: SearchBar
extension MainListCoinsViewModel {
    
    func searchResult(query: ControlProperty<String>.Element) {
        let filtered = mainListConinsObservable.value.filter {
            query.isEmpty || $0.name.contains(query.uppercased()) || $0.symbol.contains(query.lowercased())
        }
        
        filterdObservable.accept(filtered)
    }
    
    private func existsInFiltered(_ coin: Ticker) -> Bool {
        for filteredCoin in filterdObservable.value {
            if filteredCoin.symbol == coin.symbol {
                return true
            }
        }
        return false
    }
}

// MARK: Sorts
extension MainListCoinsViewModel {
    func sortName() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let sort = self.nameSortObesrvable.value
            self.resetSortImage()
            switch sort {
            case .up, .none:
                let sorted =  self.mainListConinsObservable.value.sorted(by: { $0.name > $1.name})
                self.mainListConinsObservable.accept(sorted)
                self.nameSortObesrvable.accept(.down)
            case .down:
                let sorted =  self.mainListConinsObservable.value.sorted(by: { $0.name < $1.name})
                self.mainListConinsObservable.accept(sorted)
                self.nameSortObesrvable.accept(.up)
            }
            
        }
    }
    
    func sortPrice() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let sort = self.priceSortObesrvable.value
            self.resetSortImage()
            switch sort {
            case .up, .none:
                let sorted = self.mainListConinsObservable.value.sorted(by: { $0.currentPrice.toDouble() > $1.currentPrice.toDouble()})
                self.mainListConinsObservable.accept(sorted)
                self.priceSortObesrvable.accept(.down)
            case .down:
                let sorted = self.mainListConinsObservable.value.sorted(by: { $0.currentPrice.toDouble() < $1.currentPrice.toDouble()})
                self.mainListConinsObservable.accept(sorted)
                self.priceSortObesrvable.accept(.up)
            }
        }
    }
    
    func sortFluctuation() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let sort = self.fluctuationSortObesrvable.value
            self.resetSortImage()
            switch sort {
            case .up, .none:
                let sorted = self.mainListConinsObservable.value.sorted(by: { $0.fluctuationRate.toDouble() > $1.fluctuationRate.toDouble()})
                self.mainListConinsObservable.accept(sorted)
                self.fluctuationSortObesrvable.accept(.down)
            case .down:
                let sorted = self.mainListConinsObservable.value.sorted(by: { $0.fluctuationRate.toDouble() < $1.fluctuationRate.toDouble()})
                self.mainListConinsObservable.accept(sorted)
                self.fluctuationSortObesrvable.accept(.up)
            }
        }
    }
    
    func sortTradeValue() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let sort = self.tradeValueSortObesrvable.value
            self.resetSortImage()
            switch sort {
            case .up, .none:
                let sorted = self.mainListConinsObservable.value.sorted(by: { $0.tradeValue.toDouble() > $1.tradeValue.toDouble()})
                self.mainListConinsObservable.accept(sorted)
                self.tradeValueSortObesrvable.accept(.down)
            case .down:
                let sorted = self.mainListConinsObservable.value.sorted(by: { $0.tradeValue.toDouble() < $1.tradeValue.toDouble()})
                self.mainListConinsObservable.accept(sorted)
                self.tradeValueSortObesrvable.accept(.up)
            }
        }
    }
    
    func resetSortImage() {
        tradeValueSortObesrvable.accept(.none)
        fluctuationSortObesrvable.accept(.none)
        priceSortObesrvable.accept(.none)
        nameSortObesrvable.accept(.none)
    }
}
