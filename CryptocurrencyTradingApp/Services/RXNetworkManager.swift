//
//  RXNetworkManager.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/03/13.
//

import Foundation
import RxSwift

struct RXnetworkManager {
    func download(request: URLRequest) -> Observable<Data?> {
        return Observable.create { emitter in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    emitter.onError(error)
                    return
                }
                
                if let data = data {
                    emitter.onNext(data)
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
