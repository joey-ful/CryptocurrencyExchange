//
//  AssetStatusViewModel.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/29.
//

import Foundation

class AssetStatusListViewModel {
    private(set) var assetStatusList: [AssetStatus] = []
    private(set) var filtered: [AssetStatus] = []
    private let networkManager = NetworkManager(networkable: NetworkModule())
    private let jwtGenerator = JWTGenerator()
    private let markets: [UpbitMarket]
    
    func assetStatusViewModel(at index: Int) -> AssetStatusViewModel {
        return AssetStatusViewModel(data: filtered[index])
    }
    
    init(_ markets: [UpbitMarket]) {
        self.markets = markets
        initiateRestAPI()
    }
}

// MARK: RestAPI
extension AssetStatusListViewModel {
    
    private func initiateRestAPI() {
        let route = UpbitRoute.assetsstatus
        
        networkManager.request(with: route,
                               header: route.JWTHeader,
                               requestType: .requestWithHeader)
        { (parsedResult: Result<[UpbitAssetStatus], Error>) in
            
            switch parsedResult {
            case .success(let parsedData):
                let data: [AssetStatus] = parsedData.map { assetStatus in
                    let markets = self.markets.filter { $0.market.contains(assetStatus.currency) }
                    let name = markets.isEmpty ? "-" : markets[0].koreanName
                    let withdraw = assetStatus.walletState == "working" || assetStatus.walletState == "withdraw_only"
                    let deposit = assetStatus.walletState == "working" || assetStatus.walletState == "deposit_only"
                    
                    return AssetStatus(coinName: name,
                                       symbol: assetStatus.currency,
                                       withdraw: withdraw,
                                       deposit: deposit)
                }
                self.filtered = data
                self.assetStatusList = data
                NotificationCenter.default.post(name: .assetStatusNotification, object: nil)
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
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
