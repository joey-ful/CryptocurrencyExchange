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
    private let restAPIManager = RestAPIManager()
    
    func assetStatusViewModel(at index: Int) -> AssetStatusViewModel {
        return AssetStatusViewModel(data: filtered[index])
    }
    
    init() {
        initiateRestAPI()
    }
}

// MARK: RestAPI
extension AssetStatusListViewModel {
    
    private func initiateRestAPI() {
        restAPIManager.fetch(type: .assetsStatusAll,
                             paymentCurrency: .KRW)
        { (parsedResult: Result<RestAPIAssetStatus, Error>) in
            
            switch parsedResult {
            case .success(let parsedData):
                let data: [AssetStatus] = parsedData.data.map { symbol, assetStatus in
                    let coin = CoinType.coin(symbol: symbol) ?? .unverified
                    return AssetStatus(coinName: coin.name,
                                       symbol: coin.symbol,
                                       withdraw: assetStatus.withdrawStatus,
                                       deposit: assetStatus.depositStatus)
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
