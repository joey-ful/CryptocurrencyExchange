//
//  WebSocketURL.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/02/11.
//

import Foundation

enum WebSocketURL {
    case bithumb
    case upbit
    
    var urlString: String {
        switch self {
        case .bithumb:
            return "wss://pubwss.bithumb.com/pub/ws"
        case .upbit:
            return "wss://api.upbit.com/websocket/v1"
        }
    }
}
