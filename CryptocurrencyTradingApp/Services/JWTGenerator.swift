//
//  JWTGenerator.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/02/15.
//

import Foundation
import CryptoKit

struct JWTGenerator {
    func token() -> String? {
        guard let privateKey = UpbitRoute.privateKey,
              let publicKey = UpbitRoute.publicKey
        else { return nil }
        
        let symmetricPrivateKey = SymmetricKey(data: Data(privateKey.utf8))
        
        let header = Header()
        let payload = Payload(access_key: publicKey)

        guard let headerJSONData = try? JSONEncoder().encode(header),
              let payloadJSONData = try? JSONEncoder().encode(payload)
        else { return nil }
        
        let headerBase64String = headerJSONData.urlSafeBase64EncodedString()
        let payloadBase64String = payloadJSONData.urlSafeBase64EncodedString()
        let toSign = Data((headerBase64String + "." + payloadBase64String).utf8)

        let signature = HMAC<SHA256>.authenticationCode(for: toSign, using: symmetricPrivateKey)
        let signatureBase64String = Data(signature).urlSafeBase64EncodedString()

        let token = [headerBase64String, payloadBase64String, signatureBase64String].joined(separator: ".")
        
        return token
    }
}
