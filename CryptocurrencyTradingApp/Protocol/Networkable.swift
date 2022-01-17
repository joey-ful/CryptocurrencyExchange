//
//  Networkable.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/17.
//

import Foundation

protocol Networkable {
    mutating func runDataTask(request: URLRequest, completionHandler: @escaping (Result<Data,Error>) -> Void)
}
