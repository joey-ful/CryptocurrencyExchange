//
//  ViewController.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/17.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    let networkManager = NetworkManager(networkable: NetworkModule())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkManager.request(with: UpbitRoute.market,
                               requestType: .requestWithQueryItems) { (result: Result<[UpbitMarket], Error>) in
            
            switch result {
            case .success(let data):
                let markets = data.filter { $0.market.contains("KRW") }
                self.initTabBar(with: markets)
            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }

    private func initTabBar(with markets: [UpbitMarket]) {
        tabBar.backgroundColor = .white
        tabBar.barTintColor = UIColor.white // TabBar 의 배경 색
        tabBar.tintColor = UIColor.black // TabBar Item 이 선택되었을때의 색
        tabBar.unselectedItemTintColor = UIColor.systemGray // TabBar Item 의 기본 색

        let mainViewController = MainListViewController(viewModel: MainListCoinsViewModel(markets))
        let firstViewController = UINavigationController(rootViewController: mainViewController)
        firstViewController.tabBarItem.image = UIImage(systemName: "chart.line.uptrend.xyaxis")
        firstViewController.tabBarItem.title = "거래소" // TabBar Item 의 이름

        let secondViewController = UINavigationController(rootViewController: AssetStatusViewController(viewModel: AssetStatusListViewModel()))
        secondViewController.tabBarItem.image = UIImage(systemName: "arrow.left.and.right.square")
        secondViewController.tabBarItem.title = "입출금"

        tabBar.isHidden = false
        setViewControllers([firstViewController, secondViewController], animated: true)
    }
}
