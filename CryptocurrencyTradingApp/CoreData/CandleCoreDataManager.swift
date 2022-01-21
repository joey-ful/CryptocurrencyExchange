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
    
    func read(date: Double) -> CandleData? {
        guard let candleDataList = try? context.fetch(CandleData.fetchRequest()) else { return nil }
        
        let matchingCandleData = candleDataList.filter { $0.date == date }
        return matchingCandleData == [] ? nil : matchingCandleData[0]
    }
    
    func create(date: Double, openPrice: String, closePrice: String, highPrice: String, lowPrice: String, tradeVolume: String) {
        let candleData = CandleData(context: context)
        candleData.date = date
        candleData.openPrice = openPrice
        candleData.closePrice = closePrice
        candleData.highPrice = highPrice
        candleData.lowPrice = lowPrice
        candleData.tradeVolume = tradeVolume
        saveContext()
    }
}
