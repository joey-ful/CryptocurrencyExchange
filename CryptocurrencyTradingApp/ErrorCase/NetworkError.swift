//
//  NetworkError.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/17.
//

import Foundation

enum NetworkError: LocalizedError, Equatable {
    case badResponse
    case invalidData
    case invalidURL
    case unverifiedCoin
    case overlappingRequest
    case other(Error)
    
    var errorDescription: String? {
        switch self {
        case .badResponse:
            return "유효한 HTTP 응답이 아닙니다"
        case .invalidData:
            return "유효한 데이터가 아닙니다"
        case .invalidURL:
            return "유효한 URL이 아닙니다"
        case .unverifiedCoin:
            return "확인되지 않은 코인입니다"
        case .overlappingRequest:
            return "중복된 요청입니다"
        case .other(let error):
            return error.localizedDescription
        }
    }
    
    static func map(_ error: Error) -> NetworkError {
      return (error as? NetworkError) ?? .other(error)
    }
    
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
}
