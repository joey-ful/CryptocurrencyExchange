//
//  URLRequestBuilder.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/02/11.
//

import Foundation

enum URLRequestBuilder {
    case request
    case requestWithHeader
    
    func buildRequest(route: Route,
                      queryItems: [URLQueryItem]?,
                      header: [String:String]?,
                      bodyParameters: [String:Any]?,
                      httpMethod: HTTPMethod) -> URLRequest?
    {
        guard let url = createURL(route: route, with: queryItems) else { return nil }
        var urlRequest: URLRequest?
        switch self {
        case .request:
            urlRequest = buildRequest(httpMethod, url)
        case .requestWithHeader:
            urlRequest = buildRequestWithHeader(header, httpMethod, url)
        }

        return urlRequest
    }
    
    private func buildRequest(_ httpMethod: HTTPMethod, _ url: URL) -> URLRequest? {
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.type
        
        return urlRequest
    }
    
    private func buildRequestWithHeader(_ header: [String: String]?,
                                        _ httpMethod: HTTPMethod,
                                        _ url: URL) -> URLRequest?
    {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.type
        
        header?.forEach { key, value in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
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
