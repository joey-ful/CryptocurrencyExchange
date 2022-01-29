//
//  AssetStatusHeaderViewModel.swift
//  CryptocurrencyTradingApp
//
//  Created by 홍정아 on 2022/01/29.
//

import Foundation

class AssetStatusHeaderViewModel {
    private weak var assetStatusListViewModel: AssetStatusListViewModel?
    private var sorts: [Sort] = [.none, .none, .none]
    
    @objc func sortName() {
        updateSorts(targetIndex: 0)
    }
    
    @objc func sortWithdraw() {
        updateSorts(targetIndex: 1)
    }
    
    @objc func sortDeposit() {
        updateSorts(targetIndex: 2)
    }
    
    var nameSort: Sort {
        return sorts[0]
    }
    
    var withdrawSort: Sort {
        return sorts[1]
    }
    
    var depositSort: Sort {
        return sorts[2]
    }
    
    
    init(assetStatusListViewModel: AssetStatusListViewModel) {
        self.assetStatusListViewModel = assetStatusListViewModel
    }
    
    private func updateSorts(targetIndex: Int) {
        sorts = sorts.enumerated().map { index, value in
            if index == targetIndex {
                return sorts[targetIndex] == .down ? .up : .down
            } else {
                return .none
            }
        }
        
        switch targetIndex {
        case 0:
            assetStatusListViewModel?.sortName(type: sorts[0])
        case 1:
            assetStatusListViewModel?.sortWithdraw(type: sorts[1])
        default:
            assetStatusListViewModel?.sortDeposit(type: sorts[2])
        }
        
        NotificationCenter.default.post(name: .updateSortIconsNotification, object: nil)
    }
}
