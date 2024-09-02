//
//  UIColorSet.swift
//  Smssme
//
//  Created by 임혜정 on 8/28/24.
//

import UIKit

// MARK: - 헥사코드 사용예시 UIColor(hex: "#000000")

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0
        let a = CGFloat(1.0)
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}



