//
//  ViewController.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/17.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.backgroundColor = .white
        tabBar.barTintColor = UIColor.white // TabBar 의 배경 색
        tabBar.tintColor = UIColor.black // TabBar Item 이 선택되었을때의 색
        tabBar.unselectedItemTintColor = UIColor.systemGray // TabBar Item 의 기본 색

        let mainViewController = MainListViewController(viewModel: MainListCoinsViewModel())
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
