//
//  File.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/01/28.
//

import Foundation
import CoreData

extension CandleData10M {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CandleData10M> {
        return NSFetchRequest<CandleData10M>(entityName: "CandleData10M")
    }

    @NSManaged public var openPrice: Double
    @NSManaged public var closePrice: Double
    @NSManaged public var lowPrice: Double
    @NSManaged public var tradeVolume: Double

}

extension CandleData10M : Identifiable {

}
