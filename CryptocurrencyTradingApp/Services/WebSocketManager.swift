//
//  WebsocketManager.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/01/17.
//

import Foundation

class WebSocketManager: NSObject {
    private var webSocket: URLSessionWebSocketTask?
    
    func createWebSocket(exchange: WebSocketURL) {
        let url = URL(string: exchange.urlString)!
        webSocket = URLSession.shared.webSocketTask(with: url)
        webSocket?.delegate = self
        webSocket?.resume()
    }
    
    func connectWebSocket<T: WebSocketDataModel, S: WebSocketParameter>(parameter: S,
                             completion: @escaping (Result<T?, Error>) -> Void)
    {
        sendMessage(parameter)
        receiveMessage(completion: completion)
    }
    
    private func sendMessage<S: WebSocketParameter>(_ parameter: S) {
        let encoder = JSONEncoder()
        let parameters = parameter
        guard let data = try? encoder.encode(parameters) else {
            return
        }
        let message = URLSessionWebSocketTask.Message.data(data)
        webSocket?.send(message) { error in
            if let error = error {
                assertionFailure("\(error)")
            }
        }
    }
    
    private func receiveMessage<T: WebSocketDataModel>(completion: @escaping (Result<T?, Error>) -> Void) {
        webSocket?.receive(completionHandler: { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let message):
                    if message.contains("status") == false {
                        self?.parse(text: message, completion: completion)
                    }
                default:
                    break
                }
            case .failure(let error):
                assertionFailure("\(error)")
            }
            self?.receiveMessage(completion: completion)
        })
    }
    
    private func parse<T: WebSocketDataModel>(text: String,
                                              completion: @escaping (Result<T?, Error>) -> Void) {
        let data = Data(text.utf8)
        
        do {
            var parsedData: T?
            if text.contains("ticker") {
                parsedData = try JSONDecoder().decode(BithumbWebSocketTicker.self, from: data) as? T
            } else if text.contains("transaction") {
                parsedData = try JSONDecoder().decode(BithumbWebSocketTransaction.self, from: data) as? T
            } else if text.contains("orderbookdepth") {
                parsedData = try JSONDecoder().decode(BithumbWebSocketOrderBook.self, from: data) as? T
            }
            guard let parsedData = parsedData else { return }
            DispatchQueue.main.async {
                completion(.success(parsedData))
            }
        } catch {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
    
    private func ping() {
        webSocket?.sendPing(pongReceiveHandler: { error in
            if let error = error {
                print("Ping error: \(error)")
            }
            DispatchQueue.global().asyncAfter(deadline: .now() + 30) { [weak self] in
                self?.ping()
            }
        })
    }
    
    func close() {
        let reason = Data("Close webSocket before view transition".utf8)
        webSocket?.cancel(with: .normalClosure, reason: reason)
    }
}

extension WebSocketManager: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession,
                    webSocketTask: URLSessionWebSocketTask,
                    didOpenWithProtocol protocol: String?)
    {
        print("WebSocket에 연결되었습니다.")
        ping()
    }
    
    func urlSession(_ session: URLSession,
                    webSocketTask: URLSessionWebSocketTask,
                    didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
                    reason: Data?)
    {
        
        if let reason = reason,
           let closeReason = String(data: reason, encoding: .utf8) {
            print("WebSocket 연결이 끊겼습니다: \(closeReason)")
        } else {
            print("WebSocket 연결이 끊겼습니다.")
        }
    }
}

