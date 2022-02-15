//
//  UpbitRoute.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/02/11.
//

import Foundation

enum UpbitRoute: Route {
    case market
    case ticker
    case tickerAll
    case trades
    case candles(ChartInterval)
    case orderbook
    case orderbookAll
    case assetsstatus
    
    var scheme: String {
        return "https"
    }
    
    var baseURL: String {
        return "//api.upbit.com"
    }
    
    var path: String {
        switch self {
        case .market:
            return "/v1/market/all"
        case .ticker, .tickerAll:
            return "/v1/ticker"
        case .trades:
            return "/v1/trades/ticks"
        case .candles(let chartInterval):
            return "/v1/candles/\(chartInterval.upbitPath)"
        case .orderbook, .orderbookAll:
            return "/v1/orderbook"
        case .assetsstatus:
            return "/v1/status/wallet"
        }
    }
    
    var JWTHeader: [String: String]? {
        var header: [String: String] = [:]
        header["Content-Type"] = "application/json"
        guard let token = JWTGenerator().token() else { return nil }
        header["Authorization"] = "Bearer \(token)"
        
        return header
    }
    
    private static var apiKeyDictionary: [String: String]? {
        guard let filePath = Bundle.main.path(forResource: "APIKey", ofType: "plist") else { return nil }
        let dictionary = NSDictionary(contentsOfFile: filePath)
        return dictionary as? [String: String]
    }
    
    static var publicKey: String? {
        guard let dictionary = apiKeyDictionary else { return nil }
        return dictionary["UpbitPublicKey"]
    }
    
    static var privateKey: String? {
        guard let dictionary = apiKeyDictionary else { return nil }
        return dictionary["UpbitPrivateKey"]
    }
    
    //    var tickerAllQueryItems: [URLQueryItem]? {
    //        guard case .tickerAll(let currency) = self else { return nil }
    //
    //        let markets: [String] = CoinType.allCases.compactMap {
    //            if $0 == .unverified { return nil }
    //            if currency == .BTC && $0 == .btc { return nil }
    //            return "\(currency)-\($0.symbol)"
    //        }
    //        return [URLQueryItem(name: "markets", value: markets.joined(separator: ", "))]
    //    }
    //
    //    var orderbookAllQueryItems: [URLQueryItem]? {
    //        guard case .orderbookAll(let currency) = self else { return nil }
    //
    //        let markets: [String] = CoinType.allCases.compactMap {
    //            if $0 == .unverified { return nil }
    //            if currency == .BTC && $0 == .btc { return nil }
    //            return "\(currency)-\($0.symbol)"
    //        }
    //        return [URLQueryItem(name: "markets", value: markets.joined(separator: ", "))]
    //    }
    /// 유의종목 필드와 같은 상세 정보 노출 여부 (선택 파라미터)

    func marketQueryItems(isDetails: Bool?) -> [URLQueryItem]? {
        guard case .market = self,
              let isDetails = isDetails
        else {
            return nil
        }
        
        return [URLQueryItem(name: "isDetails", value: "\(isDetails)")]
    }
    
    /**
     lastDate 포맷 : yyyy-MM-dd'T'HH:mm:ss'Z' or yyyy-MM-dd HH:mm:ss. 비워서 요청시 가장 최근 캔들
     candleCount : 캔들 개수(최대 200개까지 요청 가능)
     **/
    func candlesQueryItems(coin: UpbitMarket, lastDate: String? = nil, candleCount: Int? = nil) -> [URLQueryItem]? {
        guard case .candles(_) = self else { return [] }
        
        let coinQueryItem = URLQueryItem(name: "market", value: coin.market)
        var queryItems: [URLQueryItem] = [coinQueryItem]
        
        if let lastDate = lastDate {
            queryItems.append(URLQueryItem(name: "to", value: lastDate))
        }
        if let count = candleCount {
            queryItems.append(URLQueryItem(name: "count", value: "\(count)"))
        }
        
        return queryItems
    }
    
    func tickerQueryItems(coins: [UpbitMarket]) -> [URLQueryItem]? {
        guard case .ticker = self else { return nil }
        
        let markets: [String] = coins.compactMap {
            return $0.market
        }
        
        return [URLQueryItem(name: "markets", value: markets.joined(separator: ", "))]
    }
    
    func tickerVariousCurrenciesQueryItems(markets: [(UpbitMarket, PaymentCurrency)]) -> [URLQueryItem]? {
        guard case .ticker = self else { return nil }
        
        let markets: [String] = markets.compactMap {
            return $0.0.market
        }
        
        return [URLQueryItem(name: "markets", value: markets.joined(separator: ", "))]
    }
    
    func orderbookQueryItems(coins: [UpbitMarket]) -> [URLQueryItem]? {
        guard case .orderbook = self else { return nil }
        
        let markets: [String] = coins.compactMap {
            return $0.market
        }
        
        return [URLQueryItem(name: "markets", value: markets.joined(separator: ", "))]
    }
    
    func orderbookVariousCurrenciesQueryItems(markets: [(UpbitMarket, PaymentCurrency)]) -> [URLQueryItem]? {
        guard case .orderbook = self else { return nil }
        
        let markets: [String] = markets.compactMap {
            return $0.0.market
        }
        
        return [URLQueryItem(name: "markets", value: markets.joined(separator: ", "))]
    }
    
    func tradesQueryItems(market: UpbitMarket, toTime: String? = nil, count: Int?, cursor: String? = nil, daysAgo: Int? = nil) -> [URLQueryItem]? {

        var queryItems = [URLQueryItem(name: "market", value: market.market)]

        if let toTime = toTime {
            let validToTime = URLQueryItem(name: "to", value: toTime)
            queryItems.append(validToTime)
        }
        
        if let count = count {
            let validCount = URLQueryItem(name: "count", value: count.description)
            queryItems.append(validCount)
        }
         
        if let cursor = cursor {
            let validCursor = URLQueryItem(name: "cursor", value: cursor.description)
            queryItems.append(validCursor)
        }
        
        if let daysAgo = daysAgo {
            let validDaysAgo = URLQueryItem(name: "daysAgo", value: daysAgo.description)
            queryItems.append(validDaysAgo)
        }
        
        return queryItems
    }
}
