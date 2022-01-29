//
//  File.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/01/28.
//

import Foundation
import CoreData

extension CandleData30M {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CandleData30M> {
        return NSFetchRequest<CandleData30M>(entityName: "CandleData30M")
    }

    @NSManaged public var openPrice: Double
    @NSManaged public var closePrice: Double
    @NSManaged public var lowPrice: Double
    @NSManaged public var tradeVolume: Double

}

extension CandleData30M : Identifiable {

}
