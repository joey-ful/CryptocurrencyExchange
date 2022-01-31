//
//  CoreDataStack.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/21.
//

import Foundation
import CoreData

final class CandleCoreDataManager {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CryptocurrencyTradingApp")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private lazy var context: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.parent = persistentContainer.viewContext
        return managedObjectContext
    }()
        
    private func saveContext() {
            guard context.hasChanges else { return }
            
            do {
                
                try context.save()
            } catch {
                let nserror = error as NSError
            }
    }
    
    func read(entityName: RequestChartInterval, coin: CoinType) -> [CandleStickCoreDataEntity]? {
            let candlePredicate = NSPredicate(format: "coin == %@", coin.rawValue)
                if entityName.rawValue.contains("1m") {
                    let fetchRequest = CandleData1M.fetchRequest()
                    fetchRequest.predicate = candlePredicate
                    return try? context.fetch(fetchRequest)
                    
                } else if entityName.rawValue.contains("10m") {
                    let fetchRequest = CandleData10M.fetchRequest()
                    fetchRequest.predicate = candlePredicate
                    return try? context.fetch(fetchRequest)
                    
                } else if entityName.rawValue.contains("30m") {
                    let fetchRequest = CandleData30M.fetchRequest()
                    fetchRequest.predicate = candlePredicate
                    return try? context.fetch(fetchRequest)
                    
                } else if entityName.rawValue.contains("1h") {
                    let fetchRequest = CandleData1H.fetchRequest()
                    fetchRequest.predicate = candlePredicate
                    return try? context.fetch(fetchRequest)
                    
                } else if entityName.rawValue.contains("24h") {
                    let fetchRequest = CandleData24H.fetchRequest()
                    fetchRequest.predicate = candlePredicate
                    return try? context.fetch(fetchRequest)
                    
                } else {
                    return nil
                }
        }

    
    private func filter(_ entity: RequestChartInterval) -> NSManagedObject? {
            if entity.rawValue.contains("1m") {
                return CandleData1M(context: context)
                
            } else if entity.rawValue.contains("10m") {
                return CandleData10M(context: context)
                
            } else if entity.rawValue.contains("30m") {
                return CandleData30M(context: context)
                
            } else if entity.rawValue.contains("1h"){
                return CandleData1H(context: context)
                
            } else if entity.rawValue.contains("24h") {
                return CandleData24H(context: context)
                
            } else {
                return nil
            }

    }
    
    private func create(coin: CoinType,entityName: RequestChartInterval, date: String, openPrice: Double, closePrice: Double, highPrice: Double, lowPrice: Double, tradeVolume: Double) {
        guard let entity = filter(entityName) else {
            return
        }
        entity.setValue(coin.rawValue, forKey: "coin")
        entity.setValue(date, forKey: "date")
        entity.setValue(openPrice, forKey: "openPrice")
        entity.setValue(closePrice, forKey: "closePrice")
        entity.setValue(highPrice, forKey: "highPrice")
        entity.setValue(lowPrice, forKey: "lowPrice")
        entity.setValue(tradeVolume, forKey: "tradeVolume")

        saveContext()
    }

    func addToCoreData(coin: CoinType, _ candleStick: [[CandleStick.CandleStickData]], entityName: RequestChartInterval) {
        guard let data = candleStick.last?[0] else {
            return
        }
        let fetchResult = read(entityName: entityName, coin: coin)
        let lastDate = self.convertToInt(data)
        guard let lastDBDate = fetchResult?.last?.date else {
            return
        }
        if lastDBDate != lastDate {
            candleStick.forEach { index in
                create(coin: coin, entityName: entityName, date: convertToInt(index[0]), openPrice: convert(index[1]), closePrice: convert(index[2]), highPrice: convert(index[3]), lowPrice: convert(index[4]), tradeVolume: convert(index[5]))
            }
//            completion(result)
        } else {
            print("중복됨")
        }
       
//        candleStick.forEach { index in
//            create(coin: coin, entityName: entityName, date: convertToInt(index[0]), openPrice: convert(index[1]), closePrice: convert(index[2]), highPrice: convert(index[3]), lowPrice: convert(index[4]), tradeVolume: convert(index[5]))
//        }
    }
    
    private func convert(_ candleData: CandleStick.CandleStickData) -> Double {
        switch candleData {
        case .string(let result):
            return Double(result) ?? .zero
        case .integer(let date):
            return Double(date)
        }
    }
    
    private func convertToInt(_ candleData: CandleStick.CandleStickData) -> String {
        switch candleData {
        case .string(let result):
            return String(result)
        case .integer(let date):
            return String(date)
        }
    }
}
