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
    let isWeekOfStart: Bool
    let isThisMonth: Bool
    var weekSection: Int
    //일요일이면 +1 section 값이 동일한 애들끼리 백그라운드 컬러 처리
    init(date: Date = Date(),
         isWeekOfStart: Bool = false,
         isThisMonth: Bool = true,
         weekSection: Int = 0) {
        self.date = date
        self.isWeekOfStart = isWeekOfStart
        self.isThisMonth = isThisMonth
        self.weekSection = weekSection
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

enum ExpenseType: String {
    case housing = "주거비"
    case medical = "의료비"
    case food = "식비"
    case entertainment = "여가활동비"
    case shopping = "쇼핑"
    case traffic = "교통비"
    // sfSymbols -> 16이상 버전으로만 구성
    var imageName: String {
        switch self {
        case .housing:
            return "house.circle.fill"
        case .medical:
            return "pill.circle"
        case .food:
            return "fork.knife.circle.fill"
        case .entertainment:
            return "party.popper"
        case .shopping:
            return "cart"
        case .traffic:
            return "car.circle.fill"
        }
    }
    
}




