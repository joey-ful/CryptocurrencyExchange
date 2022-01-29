//
//  CandleData24H+CoreDataProperties.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/01/28.
//

import Foundation
import CoreData

extension CandleData24H {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CandleData24H> {
        return NSFetchRequest<CandleData24H>(entityName: "CandleData24H")
    }

    @NSManaged public var openPrice: Double
    @NSManaged public var closePrice: Double
    @NSManaged public var lowPrice: Double
    @NSManaged public var tradeVolume: Double

}

extension CandleData24H : Identifiable {

}
