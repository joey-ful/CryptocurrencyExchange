//
//  JWTModel.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/02/15.
//

import Foundation

struct Header: Encodable {
    let alg = "HS256"
    let typ = "JWT"
}

struct Payload: Encodable {
    let access_key: String
    let nonce = UUID()
    let query_hash: String?
    let query_hash_alg: String?
}

extension Payload {
    init(access_key: String) {
        self.init(access_key: access_key, query_hash: nil, query_hash_alg: nil)
    }
}
