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
    
    
}

// MARK: RestAPI
extension AssetStatusListViewModel {
    
    private func initiateRestAPI() {
        restAPIManager.fetch(type: .tickerAll,
                             paymentCurrency: .KRW)
        { (parsedResult: Result<RestAPIAssetStatus, Error>) in
            
            switch parsedResult {
            case .success(let parsedData):
                let data = self.mirror(parsedData.data)
//                self.assetStatusList = data
                NotificationCenter.default.post(name: .assetStatusNotification, object: nil)
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    private func mirror(_ data: RestAPIAssetStatus.Data) -> [MainListCoin] {
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
