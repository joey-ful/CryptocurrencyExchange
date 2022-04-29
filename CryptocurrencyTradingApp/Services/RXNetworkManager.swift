//
//  RXNetworkManager.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/03/13.
//

import Foundation
import RxSwift

struct RXnetworkManager {
    func download<T: Decodable>(request: URLRequest) -> Observable<T> {
        return Observable.create { emitter in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    emitter.onError(error)
                    return
                }
                
                if let data = data, let result = try? JSONDecoder().decode(T.self, from: data) {
                    emitter.onNext(result)
                }
                
                emitter.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
