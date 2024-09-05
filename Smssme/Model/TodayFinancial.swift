//
//  TodayFinancia.swift
//  Smssme
//
//  Created by 전성진 on 8/29/24.
//

import Foundation

// MARK: - 오늘의 주요 경제 지표
/// - title: 항목명
/// - value: 항목값
/// - range : 변동폭
struct TodayFinancial {
    let title: String
    let value: Double
    let range: Double 
}
