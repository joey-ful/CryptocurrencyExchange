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
    lazy var context: NSManagedObjectContext = persistentContainer.viewContext

    func saveContext() {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func read(date: String) -> CandleData? {
        guard let candleDataList = try? context.fetch(CandleData.fetchRequest()) else { return nil }
        
        let matchingCandleData = candleDataList.filter { $0.date == date }
        return matchingCandleData == [] ? nil : matchingCandleData[0]
    }
    
    func read() -> [CandleData]? {
        return try? context.fetch(CandleData.fetchRequest())
    }
    
    func create(date: String, openPrice: Double, closePrice: Double, highPrice: Double, lowPrice: Double, tradeVolume: Double) {
        let candleData = CandleData(context: context)
        candleData.date = date
        candleData.openPrice = openPrice
        candleData.closePrice = closePrice
        candleData.highPrice = highPrice
        candleData.lowPrice = lowPrice
        candleData.tradeVolume = tradeVolume
        saveContext()
    }
    
    func addToCoreData(_ candleStick: [[CandleStick.CandleStickData]]) {
        candleStick.forEach { index in
            create(date: convert(index[0]), openPrice: convert(index[1]), closePrice: convert(index[2]), highPrice: convert(index[3]), lowPrice: convert(index[4]), tradeVolume: convert(index[5]))
        }
    }
    
    private func convert(_ candleData: CandleStick.CandleStickData) -> Double {
        switch candleData {
        case .string(let result):
            return Double(result) ?? .zero
        case .integer(let date):
            return Double(date)
        }
    }
    
    private func convert(_ candleData: CandleStick.CandleStickData) -> String {
        switch candleData {
        case .string(let result):
            return String(result)
        case .integer(let date):
            return String(date)
        }
    }
}
