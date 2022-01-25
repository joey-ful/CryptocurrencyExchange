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

    @NSManaged public var date: Double
    @NSManaged public var openPrice: String?
    @NSManaged public var closePrice: String?
    @NSManaged public var highPrice: String?
    @NSManaged public var lowPrice: String?
    @NSManaged public var tradeVolume: String?

}

extension CandleData : Identifiable {

}
