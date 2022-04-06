//
//  AssetStatusViewModel.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/29.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa


class AssetStatusListViewModel {
    private var assetObservable = BehaviorRelay<[AssetStatus]>(value: [])
    var filterdObservable = BehaviorRelay<[AssetStatus]>(value: [])
    private let markets: [UpbitMarket]
    private var diposedBag = DisposeBag()
    
    init(_ markets: [UpbitMarket]) {
        self.markets = markets
        initAPI()
    }
    
    func searchResult(query: ControlProperty<String>.Element) {
        _ = assetObservable.map {
            $0.filter{
                query.isEmpty || $0.coinName.contains(query.uppercased()) || $0.symbol.contains(query.uppercased())
            }
        }.subscribe { self.filterdObservable.accept($0) }
    }
}

// MARK: RestAPI
extension AssetStatusListViewModel {
    
    func initAPI() {
        let route = UpbitRoute.assetsstatus
        let requestBuilder = URLRequestBuilder.requestWithHeader
        guard let request = requestBuilder.buildRequest(route: route, queryItems: nil, header: route.JWTHeader, bodyParameters: nil, httpMethod: .get) else { return }
            _ = RXnetworkManager().download(request: request)
            .map { (data: [UpbitAssetStatus]) in
                data.map { assetStatus -> AssetStatus in
                    let markets = self.markets.filter { $0.market.contains(assetStatus.currency) }
                    let name = markets.isEmpty ? "-" : markets[0].koreanName
                    let withdraw = assetStatus.walletState == "working" || assetStatus.walletState == "withdraw_only"
                    let deposit = assetStatus.walletState == "working" || assetStatus.walletState == "deposit_only"
                    
                    return AssetStatus(coinName: name,
                                       symbol: assetStatus.currency,
                                       withdraw: withdraw,
                                       deposit: deposit)
                }
            }
            .take(1)
            .bind(to: assetObservable)
    }
}
