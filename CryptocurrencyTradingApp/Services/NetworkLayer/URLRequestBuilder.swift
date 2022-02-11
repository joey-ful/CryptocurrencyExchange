//
//  URLRequestBuilder.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/02/11.
//

import Foundation

enum URLRequestBuilder {
    case requestWithPath
    case requestWithQueryItems
    
    func buildRequest(route: Route,
                      queryItems: [URLQueryItem]?,
                      header: [String:String]?,
                      bodyParameters: [String:Any]?,
                      httpMethod: HTTPMethod) -> URLRequest?
    {
        guard let url = createURL(route: route, with: queryItems) else { return nil }
        var urlRequest: URLRequest?
        switch self {
        case .requestWithQueryItems:
            urlRequest = buildRequstWithQueryItems(route: route,
                                                   with: queryItems,
                                                   httpMethod: httpMethod,
                                                   url: url)
        case .requestWithPath:
            urlRequest = URLRequest(url: url)
        }

        return urlRequest
    }
    
    private func buildRequstWithQueryItems(route: Route,
                                           with parameters: [URLQueryItem]?,
                                           httpMethod: HTTPMethod, url: URL) -> URLRequest?
    {
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.type
        
        return urlRequest
    }
    
    private func createURL(route: Route, with queryItems: [URLQueryItem]?) -> URL? {
        var urlComponents = URLComponents(string: route.baseURL)
        urlComponents?.scheme = route.scheme
        urlComponents?.path = route.path
        urlComponents?.queryItems = queryItems
        
        return urlComponents?.url
    }
}
