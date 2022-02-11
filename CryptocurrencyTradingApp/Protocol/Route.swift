//
//  Route.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/02/11.
//

import Foundation

protocol Route {
    var scheme: String { get }
    var baseURL: String { get }
    var path: String { get }
}
