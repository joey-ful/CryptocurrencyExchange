//
//  AssetStatusViewModel.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/29.
//

import UIKit
import UIKit.UITableView
import Combine

typealias StatusDataSource = UITableViewDiffableDataSource<Int, AssetStatus>

class AssetStatusListViewModel {
    private(set) var assetStatusList: [AssetStatus] = []
    private(set) var filtered: [AssetStatus] = []
    private let networkManager = NetworkManager(networkable: NetworkModule())
    private let markets: [UpbitMarket]
    var dataSource: StatusDataSource?
    private var subscriptions: Set<AnyCancellable> = []
    
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
    }
}

// MARK: RestAPI
extension AssetStatusListViewModel {
    
    private func assetStatus() -> AnyPublisher<[AssetStatus], NetworkError> {
            let route = UpbitRoute.assetsstatus
            return NetworkManager().dataTaskPublisher(with: route,
                                                      header: route.JWTHeader,
                                                      requestType: .requestWithHeader)
                .map { (assetStatusList: [UpbitAssetStatus]) in
                    return assetStatusList.map { assetStatus -> AssetStatus in
                        let markets = self.markets.filter { $0.market.contains(assetStatus.currency) }
                        let name = markets.isEmpty ? "-" : markets[0].koreanName
                        let withdraw = assetStatus.walletState == "working"
                        || assetStatus.walletState == "withdraw_only"
                        let deposit = assetStatus.walletState == "working"
                        || assetStatus.walletState == "deposit_only"

                        return AssetStatus(coinName: name,
                                           symbol: assetStatus.currency,
                                           withdraw: withdraw,
                                           deposit: deposit)
                    }
                }
                .eraseToAnyPublisher()
        }
        
        func initAssetStatus() {
            assetStatus()
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished: break
                    case .failure(let error):
                        assertionFailure(error.localizedDescription)
                    }
                } receiveValue: { [weak self] assetStatusList in
                    guard let self = self else { return }
                    self.filtered = assetStatusList
                    self.assetStatusList = assetStatusList
                    self.makeSnapshot()
                }
                .store(in: &subscriptions)
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
