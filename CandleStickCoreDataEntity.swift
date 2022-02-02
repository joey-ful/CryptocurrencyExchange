//
//  CoreDatEntity.swift
//  CryptocurrencyTradingApp
//
//  Created by 김준건 on 2022/01/27.
//

import Foundation
import CoreData

public class CandleStickCoreDataEntity: NSManagedObject {
    @NSManaged public var highPrice: Double
    @NSManaged public var date: String
    @NSManaged public var coin: String

}
