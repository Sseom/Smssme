//
//  DateModel.swift
//  Smssme
//
//  Created by KimRin on 8/28/24.
//

import Foundation

struct CalendarItem {
    let date: String
    let isSat: Bool
    let isHol: Bool
    
    init(date: String = "", isSat: Bool = false, isHol: Bool = false) {
        self.date = date
        self.isSat = isSat
        self.isHol = isHol
    }
}

struct BudgetItem {
    var amount: Int64
    var statement: Bool
    var category: String?
    var isAssetPlan: Bool
}

struct BudgetList {
    let title: String
    var items: [BudgetItem]
}
