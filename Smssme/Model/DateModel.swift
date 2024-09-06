//
//  DateModel.swift
//  Smssme
//
//  Created by KimRin on 8/28/24.
//

import Foundation

struct CalendarItem {
    var date: Date
    let isSat: Bool
    let isHol: Bool
    
    init(date: Date = Date(), isSat: Bool = false, isHol: Bool = false) {
        self.date = date
        self.isSat = isSat
        self.isHol = isHol
    }
}

struct AssetsItem {
    var category: String?
    var title: String?
    var amount: Int64
    var note: String?
}

struct BudgetItem {
    var amount: Int64
    var statement: Bool
    var category: String
    var date: Date
}

struct BudgetList {
    let title: String
    var items: [BudgetItem]
}

struct TransactionItem {
    let name: String
    let Amount: Int
    let isIncom: Bool
    let transactionDate: Date
    
    init(name: String = "", Amount: Int = 0, isIncom: Bool = true, transactionDate: Date = Date()) {
        self.name = name
        self.Amount = Amount
        self.isIncom = isIncom
        self.transactionDate = transactionDate
    }
}


