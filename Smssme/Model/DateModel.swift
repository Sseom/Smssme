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
    var isAssetPlan: Bool
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

struct TransactionItemEdit {
    var date: Date
    var amount: Int
    var isMinus: Bool
    var title: String
    var category: String
    var memo: String
    
    init(date: Date = Date(), amount: Int = 0, isMinus: Bool = true, title: String = "이름없음", category: String = "식비", memo: String = "한식부페") {
        self.date = date
        self.amount = amount
        self.isMinus = isMinus
        self.title = title
        self.category = category
        self.memo = memo
    }
}
