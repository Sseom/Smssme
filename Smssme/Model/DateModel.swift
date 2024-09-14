//
//  DateModel.swift
//  Smssme
//
//  Created by KimRin on 8/28/24.
//

import Foundation
import DGCharts

struct CalendarItem {
    var date: Date
    let isSat: Bool
    let isThisMonth: Bool
    
    init(date: Date = Date(), isSat: Bool = false, isThisMonth: Bool = true) {
        self.date = date
        self.isSat = isSat
        self.isThisMonth = isThisMonth
    }
}

struct AssetsItem {
    var uuid: UUID?
    var category: String?
    var title: String?
    var amount: Int64
    var note: String?
}

struct AssetsList {
    let title: String
    var items: [AssetsItem]
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
    let memo: String
    init(name: String = "", Amount: Int = 0, isIncom: Bool = true, transactionDate: Date = Date(), memo: String = "") {
        self.name = name
        self.Amount = Amount
        self.isIncom = isIncom
        self.transactionDate = transactionDate
        self.memo = memo
    }
}

// 차트 % 표시 클래스
class PercentageValueFormatter: ValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return String(format: "%.1f%%", value) // 값 뒤에 % 기호 추가
    }
}



