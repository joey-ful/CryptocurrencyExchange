//
//  File.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/01/28.
//

import Foundation
import CoreData

extension CandleData1H {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CandleData1H> {
        return NSFetchRequest<CandleData1H>(entityName: "CandleData1H")
    }

    @NSManaged public var openPrice: Double
    @NSManaged public var closePrice: Double
    @NSManaged public var lowPrice: Double
    @NSManaged public var tradeVolume: Double

}

extension CandleData1H : Identifiable {

}
