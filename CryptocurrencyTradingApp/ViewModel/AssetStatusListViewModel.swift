//
//  AssetStatusViewModel.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/29.
//

import UIKit
import RxSwift

typealias StatusDataSource = UITableViewDiffableDataSource<Int, AssetStatus>

class AssetStatusListViewModel {
    private(set) var assetStatusList: [AssetStatus] = []
    private(set) var filtered: [AssetStatus] = []
    private let networkManager = NetworkManager(networkable: NetworkModule())
    private let jwtGenerator = JWTGenerator()
    private let markets: [UpbitMarket]
    var dataSource: StatusDataSource?
    private var diposedBag = DisposeBag()
    
    func assetStatusViewModel(at index: Int) -> AssetStatusViewModel {
        return AssetStatusViewModel(data: filtered[index])
    }
    
    func makeSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, AssetStatus>()
        snapshot.appendSections([0])
        snapshot.appendItems(filtered, toSection: 0)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }

    init(_ markets: [UpbitMarket]) {
        self.markets = markets
        //        initiateRestAPI()
        initAPI()
    }
}

// MARK: RestAPI
extension AssetStatusListViewModel {
    
    private func initiateRestAPI() {
        let route = UpbitRoute.assetsstatus
        
        networkManager.request(with: route,
                               header: route.JWTHeader,
                               requestType: .requestWithHeader)
        { [weak self](parsedResult: Result<[UpbitAssetStatus], Error>) in
            
            switch parsedResult {
            case .success(let parsedData):
                let data: [AssetStatus] = parsedData.map { assetStatus in
                    let markets = self?.markets.filter { $0.market.contains(assetStatus.currency) } ?? []
                    let name = markets.isEmpty ? "-" : markets[0].koreanName
                    let withdraw = assetStatus.walletState == "working" || assetStatus.walletState == "withdraw_only"
                    let deposit = assetStatus.walletState == "working" || assetStatus.walletState == "deposit_only"
                    
                    return AssetStatus(coinName: name,
                                       symbol: assetStatus.currency,
                                       withdraw: withdraw,
                                       deposit: deposit)
                }
                self?.filtered = data
                self?.assetStatusList = data
                self?.makeSnapshot()
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    func initAPI() {
        let route = UpbitRoute.assetsstatus
        let requestBuilder = URLRequestBuilder.requestWithHeader
        guard let request = requestBuilder.buildRequest(route: route, queryItems: nil, header: route.JWTHeader, bodyParameters: nil, httpMethod: .get) else { return }
        Observable.just(request)
            .flatMap { request in RXnetworkManager().download(request: request)}
//            .map { data in try JSONDecoder().decode([UpbitAssetStatus].self, from: data)}
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
            .subscribe(onNext: { result in print(result)})
            .disposed(by: diposedBag)
    }
}

// MARK: SearchBar
extension AssetStatusListViewModel {
    
    func filter(_ target: String?) {
        let text = target?.uppercased() ?? ""
        
        if text == "" {
            filtered = assetStatusList
        } else {
            filtered = assetStatusList.filter { return $0.coinName.contains(text) || $0.symbol.contains(text) }
        }
    }
}
