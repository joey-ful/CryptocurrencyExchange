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
    
    lazy var context = persistentContainer.viewContext

    private func saveContext() {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
            }
    }
    
    func read(entityName: ChartInterval, coin: CoinType) -> [CandleStickCoreDataEntity]? {
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

    
    private func filter(_ entity: ChartInterval) -> NSManagedObject? {
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
    
    private func create(entity: NSManagedObject, coin: CoinType,entityName: ChartInterval, date: String, openPrice: Double, closePrice: Double, highPrice: Double, lowPrice: Double, tradeVolume: Double) {
 
        entity.setValue(coin.rawValue, forKey: "coin")
        entity.setValue(date, forKey: "date")
        entity.setValue(openPrice, forKey: "openPrice")
        entity.setValue(closePrice, forKey: "closePrice")
        entity.setValue(highPrice, forKey: "highPrice")
        entity.setValue(lowPrice, forKey: "lowPrice")
        entity.setValue(tradeVolume, forKey: "tradeVolume")
        saveContext()
    }

    func addToCoreData(coin: CoinType, _ candleStick: [[BithumbCandleStick.CandleStickData]], entityName: ChartInterval) {
        guard let fetched = read(entityName: entityName, coin: coin) else { return }
        
        candleStick.forEach { index in
            if fetched.filter{ $0.date == convertToInt(index[0])}.count > 0{
               return
            } else {
                guard let entity = filter(entityName) else { return }
                create(entity: entity, coin: coin, entityName: entityName, date: convertToInt(index[0]), openPrice: convert(index[1]), closePrice: convert(index[2]), highPrice: convert(index[3]), lowPrice: convert(index[4]), tradeVolume: convert(index[5]))
            }
        }
    }
    
    private func convert(_ candleData: BithumbCandleStick.CandleStickData) -> Double {
        switch candleData {
        case .string(let result):
            return Double(result) ?? .zero
        case .integer(let date):
            return Double(date)
        }
    }
    
    private func convertToInt(_ candleData: BithumbCandleStick.CandleStickData) -> String {
        switch candleData {
        case .string(let result):
            return String(result)
        case .integer(let date):
            return String(date)
        }
    }
}
