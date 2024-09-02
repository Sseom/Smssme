//
//  FinancialPlanDateModel.swift
//  Smssme
//
//  Created by 임혜정 on 9/2/24.
//

import Foundation


struct FinancialPlanDateModel {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
}
