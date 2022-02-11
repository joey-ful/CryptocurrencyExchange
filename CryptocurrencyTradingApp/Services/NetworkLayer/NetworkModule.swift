//
//  NetworkModule.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/02/11.
//

import Foundation

class NetworkModule: Networkable {
    private let rangeOfSuccessState = 200...299
    private var dataTask: [URLSessionDataTask] = []
    
    func runDataTask<T: Decodable>(request: URLRequest,
                                   completionHandler: @escaping (Result<T, Error>) -> Void) {
        
        dataTask.enumerated().forEach { (index, task) in
            if let originalRequest = task.originalRequest,
               originalRequest == request {
                task.cancel()
                if dataTask.count > index {
                    dataTask.remove(at: index)
                }
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { [self] (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completionHandler(.failure(error))
                }
                return
            }

            guard let response = response as? HTTPURLResponse,
                  rangeOfSuccessState.contains(response.statusCode) else {
                DispatchQueue.main.async {
                    completionHandler(.failure(NetworkError.badResponse))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(.failure(NetworkError.invalidData))
                }
                return
            }
            
            dataTask.enumerated().forEach { (index, task) in
                if let originalRequest = task.originalRequest,
                   originalRequest == request {
                    dataTask.remove(at: index)
                }
            }
            
            do {
                let parsedData = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(.success(parsedData))
                }
            } catch let error {
                DispatchQueue.main.async {
                    completionHandler(.failure(error))
                }
            }
        }
        
        task.resume()
        dataTask.append(task)
    }
}
