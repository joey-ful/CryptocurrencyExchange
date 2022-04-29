//
//  WebsocketManager.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/01/17.
//

import Foundation
import RxSwift

class WebSocketManager: NSObject {
    private var webSockets: [URLSessionWebSocketTask] = []
    let uuid = UUID()
    
    init(of exchange: WebSocketURL = .bithumb) {
        super.init()
        
        createWebSocket(of: exchange)
    }
    
    @discardableResult
    private func createWebSocket(of exchange: WebSocketURL) -> URLSessionWebSocketTask {
        let url = URL(string: exchange.urlString)!
        let webSocket = URLSession.shared.webSocketTask(with: url)
        webSocket.delegate = self
        webSocket.resume()
        webSockets.append(webSocket)
        return webSocket
    }
    
    func connectWebsocketRX<T: WebSocketDataModel, S: WebSocketParameter>(to exchange: WebSocketURL,
                                                                          parameter: S) -> Observable<T?>{
        return Observable.create() { emitter in 
            self.connectWebSocket(to: exchange, parameter: parameter) { (result: Result<T?, Error>) in
            switch result {
            case .success(let data):
                emitter.onNext(data)
            case .failure(let error):
                emitter.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func connectWebSocket<T: WebSocketDataModel, S: WebSocketParameter>(to exchange: WebSocketURL,
                                                                        parameter: S,
                                                                        completion: @escaping (Result<T?, Error>) -> Void)
    {
        let webSocket = createWebSocket(of: exchange)
        sendMessage(through: webSocket, parameter)
        receiveMessage(of: webSocket, completion: completion)
    }
    
    private func sendMessage<S: WebSocketParameter>(through webSocket: URLSessionWebSocketTask, _ parameter: S) {
        let encoder = JSONEncoder()
        let parameters = parameter
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
    
    private func receiveMessage<T: WebSocketDataModel>(of webSocket: URLSessionWebSocketTask, completion: @escaping (Result<T?, Error>) -> Void) {
        webSocket.receive(completionHandler: { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let message):
                    if message.contains("status") == false {
                        self?.parse(text: message, completion: completion)
                    }
                case .data(let data):
                    self?.parseUpbit(data: data, completion: completion)
                default:
                    break
                }
            case .failure(let error):
                if error.localizedDescription != "cancelled" {
                    assertionFailure("\(error)")
                }
            }
            self?.receiveMessage(of: webSocket, completion: completion)
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
                completion(.success(parsedData))
        } catch {
                completion(.failure(error))
        }
    }
    
    private func parseUpbit<T: WebSocketDataModel>(data: Data,
                                                   completion: @escaping (Result<T?, Error>) -> Void) {
        guard let text = String(data: data, encoding: .utf8) else {
            return completion(.failure(ParsingError.decodingError))
        }

        do {
            var parsedData: T?
            if text.contains("ticker") {
                parsedData = try JSONDecoder().decode(UpbitWebsocketTicker.self, from: data) as? T
            } else if text.contains("trade") {
                parsedData = try JSONDecoder().decode(UpbitWebsocketTrade.self, from: data) as? T
            } else if text.contains("orderbook") {
                parsedData = try JSONDecoder().decode(UpbitWebsocketOrderBook.self, from: data) as? T
            }
            guard let parsedData = parsedData else { return }
                completion(.success(parsedData))
        } catch {
                completion(.failure(error))
        }
    }
    
    private func ping() {
        webSockets.forEach{ $0.sendPing(pongReceiveHandler: { error in
            if let error = error,
                (error as NSError).code != -999 && (error as NSError).code != 89 {
                print("Ping error: \(error)")
            }
            
            DispatchQueue.global().asyncAfter(deadline: .now() + 110) { [weak self] in
                self?.ping()
            }
        })}
    }
    
    func close() {
        let reason = Data("Close webSocket before view transition".utf8)
        webSockets.forEach {  $0.cancel(with: .normalClosure, reason: reason) }
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

