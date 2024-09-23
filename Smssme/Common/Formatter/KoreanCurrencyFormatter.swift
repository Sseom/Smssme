//
//  KoreanCurrencyFormatter.swift
//  Smssme
//
//  Created by 임혜정 on 9/5/24.
//

import Foundation

struct KoreanCurrencyFormatter {
    static let shared = KoreanCurrencyFormatter()
    
    private let numberFormatter: NumberFormatter
    
    private init() {
        numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale(identifier: "ko_KR")
    }
    
    func string(from value: Int64) -> String {
        return numberFormatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
    
    func string(from value: Int) -> String {
        return string(from: Int64(value))
    }
    
    func number(from string: String) -> Int64? {
        let cleanString = string.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        return Int64(cleanString)
    }
    
    func formatForEditing(_ string: String) -> String {
        guard let number = number(from: string) else { return "" }
        return numberFormatter.string(from: NSNumber(value: number)) ?? ""
    }
}

// 사용 예시
extension Int64 {
    var formattedAsCurrency: String {
        return KoreanCurrencyFormatter.shared.string(from: self)
    }
}

extension Int {
    var formattedAsCurrency: String {
        return KoreanCurrencyFormatter.shared.string(from: self)
    }
}
