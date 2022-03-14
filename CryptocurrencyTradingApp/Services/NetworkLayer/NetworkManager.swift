//
//  NetworkManager.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/02/11.
//

import Foundation

import Foundation
import Combine

class NetworkManager {
    private var networkable: Networkable
    private var requestStatus: [URLRequest: NetworkState] = [:]
    
    init(networkable: Networkable = NetworkModule()) {
        self.networkable = networkable
    }
    
    func request<T: Decodable>(with route: Route,
                               queryItems: [URLQueryItem]? = nil,
                               header: [String: String]? = nil,
                               bodyParameters: [String: Any]? = nil,
                               httpMethod: HTTPMethod = .get,
                               requestType: URLRequestBuilder,
                               completionHandler: @escaping (Result<T, Error>) -> Void)
    {
        
        guard let urlRequest = requestType.buildRequest(route: route,
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
    
    func dataTaskPublisher<T: Decodable>(with route: Route,
                                         queryItems: [URLQueryItem]? = nil,
                                         header: [String: String]? = nil,
                                         bodyParameters: [String: Any]? = nil,
                                         httpMethod: HTTPMethod = .get,
                                         requestType: URLRequestBuilder) -> AnyPublisher<T, NetworkError>
    {
        guard let urlRequest = requestType.buildRequest(route: route,
                                                        queryItems: queryItems,
                                                        header: header,
                                                        bodyParameters: bodyParameters,
                                                        httpMethod: httpMethod)
        else {
            return AnyPublisher(Fail<T, NetworkError>(error: NetworkError.invalidURL))
        }
        
        if let currentStatus = requestStatus[urlRequest],
           currentStatus == .isLoading
        {
            return AnyPublisher(Fail<T, NetworkError>(error: NetworkError.overlappingRequest))
        }
        
        requestStatus[urlRequest] = .isLoading
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { [weak self] response -> Data in
                guard let httpResponse = response.response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode)
                else {
                    throw NetworkError.badResponse
                }
                self?.requestStatus.removeValue(forKey: urlRequest)
                return response.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { NetworkError.map($0) }
            .eraseToAnyPublisher()
    }
}
