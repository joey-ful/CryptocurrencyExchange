//
//  ParsingError.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/01/17.
//

import Foundation

enum ParsingError: LocalizedError {
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .decodingError:
            return "디코딩을 하는 도중 문제가 발생하였습니다."
        }
    }
}
