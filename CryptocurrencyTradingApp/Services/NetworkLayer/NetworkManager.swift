//
//  NetworkManager.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/02/11.
//

import Foundation
import RxSwift

class NetworkManager {
    private var networkable: Networkable
    
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
    
    func requestRX<T: Decodable>(with route: Route,
                                 queryItems: [URLQueryItem]? = nil,
                                 header: [String: String]? = nil,
                                 bodyParameters: [String: Any]? = nil,
                                 httpMethod: HTTPMethod = .get,
                                 requestType: URLRequestBuilder) -> Observable<T>
    {
        
        guard let urlRequest = requestType.buildRequest(route: route,
                                                        queryItems: queryItems,
                                                        header: header,
                                                        bodyParameters: bodyParameters,
                                                        httpMethod: httpMethod)
        else {
            return Observable.error(NetworkError.invalidURL)
        }
        
        return Observable.create() { [weak self] emitter  in 
            self?.networkable.runDataTask(request: urlRequest) { (result:Result<T, Error>) in 
                switch result {
                case .success(let data):
                    emitter.onNext(data)
                case .failure(let error):
                    emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}



