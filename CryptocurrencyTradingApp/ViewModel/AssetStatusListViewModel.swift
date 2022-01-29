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
    
    var headerViewModel: AssetStatusHeaderViewModel {
        return AssetStatusHeaderViewModel(assetStatusListViewModel: self)
    }
    
    func assetStatusViewModel(at index: Int) -> AssetStatusViewModel {
        return AssetStatusViewModel(data: assetStatusList[index])
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
                self.assetStatusList = parsedData.data.map { symbol, assetStatus in
                    let coin = CoinType.coin(symbol: symbol) ?? .btc
                    return AssetStatus(coinName: coin.name,
                                       symbol: coin.symbol,
                                       withdraw: assetStatus.withdrawStatus,
                                       deposit: assetStatus.depositStatus)
                }
                
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
        let text = target?.lowercased() ?? ""

        if text == "" {
            filtered = assetStatusList
        } else {
            filtered = assetStatusList.filter { return $0.coinName.contains(text) || $0.symbol.contains(text) }
        }
    }
    
    private func existsInFiltered(_ coin: AssetStatus) -> Bool {
        for filteredCoin in filtered {
            if filteredCoin.symbol == coin.symbol {
                return true
            }
        }
        return false
    }
}

// MARK: Sorts
extension AssetStatusListViewModel {
    func sortName(type: Sort) {
        switch type {
        case .up:
            assetStatusList.sort { $0.coinName < $1.coinName }
        case .down:
            assetStatusList.sort { $0.coinName > $1.coinName }
        case .none:
            break
        }
    }

    func sortWithdraw(type: Sort) {
        switch type {
        case .up:
            assetStatusList.sort { $0.withdraw < $1.withdraw }
        case .down:
            assetStatusList.sort { $0.withdraw > $1.withdraw }
        case .none:
            break
        }
    }

    func sortDeposit(type: Sort) {
        switch type {
        case .up:
            assetStatusList.sort { $0.deposit < $1.deposit }
        case .down:
            assetStatusList.sort { $0.deposit > $1.deposit }
        case .none:
            break
        }
    }
}
