//
//  Networkable.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/02/11.
//

import Foundation

protocol Networkable {
    mutating func runDataTask<T: Decodable>(request: URLRequest, completionHandler: @escaping (Result<T,Error>) -> Void)
}
