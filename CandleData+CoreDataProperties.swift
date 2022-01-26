//
//  CandleData+CoreDataProperties.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/21.
//
//

import Foundation
import CoreData


extension CandleData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CandleData> {
        return NSFetchRequest<CandleData>(entityName: "CandleData")
    }

    @NSManaged public var date: String
    @NSManaged public var openPrice: Double
    @NSManaged public var closePrice: Double
    @NSManaged public var highPrice: Double
    @NSManaged public var lowPrice: Double
    @NSManaged public var tradeVolume: Double

}

extension CandleData : Identifiable {

}
