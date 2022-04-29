//
//  NetworkModule.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/02/11.
//

import Foundation

class NetworkModule: Networkable {
    private let rangeOfSuccessState = 200...299
    private var networkStates: [URLRequest: NetworkState] = [:]
    
    func runDataTask<T: Decodable>(request: URLRequest,
                                   completionHandler: @escaping (Result<T, Error>) -> Void) {
        
        if let networkState = networkStates[request], networkState == .isLoading {
            completionHandler(.failure(NetworkError.overlappingRequest))
            return
        }
        networkStates[request] = .isLoading
        
        URLSession.shared.dataTask(with: request) { [self] (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  rangeOfSuccessState.contains(response.statusCode) else {
                      completionHandler(.failure(NetworkError.badResponse))
                      return
                  }
            
            guard let data = data else {
                completionHandler(.failure(NetworkError.invalidData))
                return
            }
            
            do {
                let parsedData = try JSONDecoder().decode(T.self, from: data)
                completionHandler(.success(parsedData))
            } catch let error {
                completionHandler(.failure(error))
            }
            networkStates.removeValue(forKey: request)
        }.resume()
    }
}
