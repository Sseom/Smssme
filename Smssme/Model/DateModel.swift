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
