//
//  String+.swift
//  Smssme
//
//  Created by KimRin on 10/4/24.
//

import Foundation

extension String {
    mutating func replace(at index: Int, with newChar: Character) {
        // 문자열의 인덱스를 계산
        let stringIndex = self.index(self.startIndex, offsetBy: index)
        
        // 기존 문자열을 배열로 변환하여 문자 교체
        self.replaceSubrange(stringIndex...stringIndex, with: String(newChar))
    }
}
