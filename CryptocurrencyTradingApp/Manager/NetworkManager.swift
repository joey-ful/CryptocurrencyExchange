//
//  NetworkManager.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/17.
//

import Foundation

class NetworkManager {
    private var networkable: Networkable
    
    init(networkable: Networkable = NetworkModule()) {
        self.networkable = networkable
    }
    
    func request(with route: Route,
                 path: String = "",
                 queryItems: [URLQueryItem]? = nil,
                 header: [String: String]? = nil,
                 bodyParameters: [String: Any]? = nil,
                 httpMethod: HTTPMethod = .get,
                 requestType: URLRequestTask,
                 completionHandler: @escaping (Result<Data, Error>) -> Void)
    {
        
        guard let urlRequest = requestType.buildRequest(route: route,
                                                        path: path,
                                                        queryItems: queryItems,
                                                        header: header,
                                                        bodyParameters: bodyParameters,
                                                        httpMethod: httpMethod)
        else {
            completionHandler(.failure(NetworkError.invalidURL))
            return
        }
        networkable.runDataTask(request: urlRequest, completionHandler: completionHandler)
    }
}
