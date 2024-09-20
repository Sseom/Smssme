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
    let dayBudget: Int
    let isThisMonth: Bool
    var weekSection: Int
    //일요일이면 +1 section 값이 동일한 애들끼리 백그라운드 컬러 처리
    init(date: Date = Date(),
         dayBudget: Bool = false,
         isThisMonth: Bool = true,
         weekSection: Int = 0) {
        self.date = date
        self.dayBudget = dayBudget
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



class Benefit {
    static let shared = Benefit()
    
    private init() {}
    
    let benefitData: [String: String] = [
        "청년 취업 및 창업 지원": "https://valley-porch-b6d.notion.site/1-1001c7ac6761489cbf12b3802a8924a7",
        "청년 주거 지원": "https://valley-porch-b6d.notion.site/2-717bb3ae189b4847806ae044d3ddb8b1",
        "청년 금융 지원": "https://valley-porch-b6d.notion.site/3-26ee2c8202ec46de854409179727c949?pvs=25",
        "청년 교육 및 자립 지원": "https://valley-porch-b6d.notion.site/4-95f275585ec54a00b0994ae2e7310b5c?pvs=25",
        "청년 복지 및 기타지원": "https://valley-porch-b6d.notion.site/5-e0eb6ef61c944c82b123284fb58adccc?pvs=4",
        "지역별 혜택": "https://valley-porch-b6d.notion.site/6-2024-28798ac02443464493f80f299772b47b?pvs=4"
    ]
}

protocol ChartDataConvertible {
    var amount: Int64 { get }
    var title: String? { get }
}

struct ChartData: ChartDataConvertible {
    var amount: Int64
    var title: String?
}
