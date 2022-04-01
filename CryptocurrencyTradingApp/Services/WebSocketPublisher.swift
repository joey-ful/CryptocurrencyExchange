//
//  WebSocketPublisher.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/04/01.
//

import Foundation
import Combine

extension URLSession {
    func webSocketPublisher<W: WebSocketParameter>(_ exchange: WebSocketURL,
                                                   _ parameter: W)
    -> WebSocketPublisher<W> {
        return WebSocketPublisher(exchange, parameter)
    }
}

class WebSocketPublisher<W: WebSocketParameter>: Publisher {
    typealias Output = Data
    typealias Failure = Error
    
    private let webSocket: URLSessionWebSocketTask
    private let parameter: W?
    
    init<T: WebSocketParameter>(_ exchange: WebSocketURL, _ parameter: T) {
        let url = URL(string: exchange.urlString)!
        let webSocket = URLSession.shared.webSocketTask(with: url)
        webSocket.resume()
        self.webSocket = webSocket
        self.parameter = parameter as? W
    }
    
    /// Subscriber가 subscribe()로 구독을 요청하면 연결이 됨 >> 그리고 이 receive()메서드가 호출됨
    /// receive 메서드는 Subscriber에게 Subscription 인스턴스를 receive(subscription:) 으로 전달해야함
    func receive<S>(subscriber: S) where S : Subscriber, Error == S.Failure, Output == S.Input {
        let subscription = WebSocketSubscription(subscriber, webSocket, parameter)
        subscriber.receive(subscription: subscription)
    }
}

// MARK: Subscription
extension WebSocketPublisher {
    class WebSocketSubscription<S: Subscriber>: Subscription where S.Input == Output, S.Failure == Failure {
        private var subscriber: S?
        private let webSocket: URLSessionWebSocketTask
        
        init<W: WebSocketParameter>(_ subscriber: S, _ webSocket: URLSessionWebSocketTask, _ parameter: W?) {
            self.subscriber = subscriber
            self.webSocket = webSocket
            sendMessage(webSocket, parameter)
            receiveMessage(webSocket)
        }
        
        /// Subscriber에게 값을 더 전달할지도 모른다고 Publisher에게 알리는 역할
        func request(_ demand: Subscribers.Demand) {
            //
        }
        
        func cancel() {
            subscriber = nil
            webSocket.cancel()
        }
        
        private func sendMessage<W: WebSocketParameter>(_ webSocket: URLSessionWebSocketTask,
                                                        _ parameter: W?)
        {
            let encoder = JSONEncoder()
            guard let parameter = parameter,
                  let data = try? encoder.encode(parameter)
            else { return }
            let message = URLSessionWebSocketTask.Message.data(data)
            
            webSocket.send(message) { error in
                if let error = error {
                    assertionFailure("\(error)")
                }
            }
        }
        
        private func receiveMessage(_ webSocket: URLSessionWebSocketTask)
        {
            guard let subscriber = subscriber else { return }

            webSocket.receive(completionHandler: { [weak self] result in
                switch result {
                case .success(let message):
                    switch message {
                    case .string(let message):
                        _ = subscriber.receive(Data(message.utf8))
                    case .data(let data):
                        _ = subscriber.receive(data)
                    default:
                        break
                    }
                case .failure(let error):
                    subscriber.receive(completion: .failure(error))
                }
                self?.receiveMessage(webSocket)
            })
        }
    }
}
