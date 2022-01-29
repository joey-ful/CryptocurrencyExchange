//
//  CandleData+CoreDataProperties.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/21.
//
//

import Foundation
import CoreData


extension CandleData1M {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CandleData1M> {
        return NSFetchRequest<CandleData1M>(entityName: "CandleData1M")
    }

    @NSManaged public var openPrice: Double
    @NSManaged public var closePrice: Double
    @NSManaged public var lowPrice: Double
    @NSManaged public var tradeVolume: Double

}

extension CandleData1M : Identifiable {

}





