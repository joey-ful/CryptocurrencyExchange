//
//  WebsocketManager.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/01/17.
//

import Foundation

class WebsocketManger: NSObject {
    private let parsingManager = ParsingManager()
    private lazy var webSocket: URLSessionWebSocketTask = {
        let url = URL(string: "wss://pubwss.bithumb.com/pub/ws")!
        let webSocket = URLSession.shared.webSocketTask(with: url)
        webSocket.delegate = self
        webSocket.resume()
        return webSocket
    }()
    
    func connectWebSocket(_ type: RequestType, _ symbols: [CoinType], _ tickTypes: [RequestTik]?) {
        sendMessage(type, symbols, tickTypes)
        receiveMessage(of: type)
    }
    
    private func ping() {
        webSocket.sendPing(pongReceiveHandler: { error in
            if let error = error {
                print("Ping error: \(error)")
            }
            DispatchQueue.global().asyncAfter(deadline: .now() + 30) { [weak self] in
                self?.ping()
            }
        })
    }
    
    private func close() {
        webSocket.sendPing { error in
            if let error = error {
                assertionFailure("\(error)")
            }
        }
    }
    
    private func sendMessage(_ type: RequestType, _ symbols: [CoinType], _ tickTypes: [RequestTik]?) {
        let encoder = JSONEncoder()
        let parameters = WebsocketParameter(type, symbols, tickTypes)
        guard let data = try? encoder.encode(parameters) else {
            return
        }
        let message = URLSessionWebSocketTask.Message.data(data)
        webSocket.send(message) { error in
            if let error = error {
                assertionFailure("\(error)")
            }
        }
    }
    
    private func receiveMessage(of type: RequestType) {
        webSocket.receive(completionHandler: { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let message):
                    if message.contains("status") == false {
                        self?.parse(text: message, to: type)
                    }
                default:
                    break
                }
            case .failure(let error):
                assertionFailure("\(error)")
            }
            self?.receiveMessage(of: type)
        })
    }
    
    private func parse(text: String, to type: RequestType) {
        let data = Data(text.utf8)
        switch type {
        case .ticker:
            let result = parsingManager.decode(from: data, to: WebSocketTicker.self)
            filter(result)
        case .transaction:
            let result = parsingManager.decode(from: data, to: WebSocketTransaction.self)
            filter(result)
        case .orderbookdepth:
            break
        }
    }
    
    private func filter<T: WebSocket>(_ parsedResult: Result<T, ParsingError>) {
        switch parsedResult {
        case .success(let data):
            sendNotification(data: data)
        case .failure(let error):
            assertionFailure(error.localizedDescription)
        }
    }
    
    private func sendNotification(data: WebSocket) {
        if let transactions = (data as? WebSocketTransaction)?.content.list {
            NotificationCenter.default.post(name: .webSocketTransactionNotification,
                                            object: nil,
                                            userInfo: ["data": transactions])
        } else if let ticker = (data as? WebSocketTicker)?.content {
            NotificationCenter.default.post(name: .webSocketTickerNotification,
                                            object: nil,
                                            userInfo: ["data": ticker ])
        }
    }
}

extension WebsocketManger: URLSessionWebSocketDelegate {
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Did connect to socket")
        ping()
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Did close connection with reason:")
    }
}

