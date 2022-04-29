////
////  MainListHeaderViewModel.swift
////  CryptocurrencyTradingApp
////
////  Created by 홍정아 on 2022/01/26.
////
//
//import Foundation
//import RxRelay
//
//class MainListHeaderViewModel {
//    private weak var mainListCoinsViewModel: MainListCoinsViewModel?
//    private var sorts: [Sort] = [.none, .none, .none, .down]
////    var nameSortObesrvable = BehaviorRelay<Sort>(value: .none)
//    @objc func sortName() {
//        updateSorts(targetIndex: 0)
//    }
//    
//    @objc func sortPrice() {
//        updateSorts(targetIndex: 1)
//    }
//    
//    @objc func sortFluctuation() {
//        updateSorts(targetIndex: 2)
//    }
//    
//    @objc func sortTradeValue() {
//        updateSorts(targetIndex: 3)
//    }
//    
//    var nameSort: Sort {
//        return sorts[0]
//    }
//    
//    var priceSort: Sort {
//        return sorts[1]
//    }
//    
//    var fluctuationSort: Sort {
//        return sorts[2]
//    }
//    
//    var tradeValueSort: Sort {
//        return sorts[3]
//    }
//    
//    init(mainListCoinsViewModel: MainListCoinsViewModel) {
//        self.mainListCoinsViewModel = mainListCoinsViewModel
//    }
//    
////    private func updateSorts(targetIndex: Int) {
////        sorts = sorts.enumerated().map { index, value in
////            if index == targetIndex {
////                return sorts[targetIndex] == .down ? .up : .down
////            } else {
////                return .none
////            }
////        }
////        
////        switch targetIndex {
////        case 0:
////            mainListCoinsViewModel?.sortName(type: sorts[0])
////        case 1:
////            mainListCoinsViewModel?.sortPrice(type: sorts[1])
////        case 2:
////            mainListCoinsViewModel?.sortFluctuation(type: sorts[2])
////        default:
////            mainListCoinsViewModel?.sortTradeValue(type: sorts[3])
////        }
////        
////        NotificationCenter.default.post(name: .updateSortNotification, object: nil)
////    }
//}
