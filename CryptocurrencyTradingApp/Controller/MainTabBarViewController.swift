//
//  ViewController.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/17.
//

import UIKit
import Combine

class MainTabBarViewController: UITabBarController {
    private let networkManager = NetworkManager(networkable: NetworkModule())
    private var subscriptions: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkManager.dataTaskPublisher(with: UpbitRoute.market, requestType: .request)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    if error != NetworkError.overlappingRequest {
                        assertionFailure(error.localizedDescription)
                    }
                }
            } receiveValue: { [weak self] (markets: [UpbitMarket]) in
                guard let self = self else { return }
                self.initTabBar(with: markets)
            }
            .store(in: &subscriptions)
    }

    private func initTabBar(with markets: [UpbitMarket]) {
        tabBar.backgroundColor = .white
        tabBar.barTintColor = UIColor.white // TabBar 의 배경 색
        tabBar.tintColor = UIColor.black // TabBar Item 이 선택되었을때의 색
        tabBar.unselectedItemTintColor = UIColor.systemGray // TabBar Item 의 기본 색

        let filteredMarkets = markets.filter { $0.market.contains("KRW") }
        let mainViewController = MainListViewController(viewModel: MainListCoinsViewModel(filteredMarkets))
        let firstViewController = UINavigationController(rootViewController: mainViewController)
        firstViewController.tabBarItem.image = UIImage(systemName: "chart.line.uptrend.xyaxis")
        firstViewController.tabBarItem.title = "거래소" // TabBar Item 의 이름

        let secondViewController = UINavigationController(rootViewController: AssetStatusViewController(viewModel: AssetStatusListViewModel(markets)))
        secondViewController.tabBarItem.image = UIImage(systemName: "arrow.left.and.right.square")
        secondViewController.tabBarItem.title = "입출금"

        tabBar.isHidden = false
        setViewControllers([firstViewController, secondViewController], animated: true)
    }
}
