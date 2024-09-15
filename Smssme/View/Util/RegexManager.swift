//
//  RegexManager.swift
//  Smssme
//
//  Created by KimRin on 9/15/24.
//

import Foundation

class RegexManager {
    static let shared = RegexManager()
    private init () {}
    
    
    
    func removeLeadingZeros(from text: String) -> String {
        let regexPattern = "\\b0+(\\d{1,})\\b"
        do {
            let regex = try NSRegularExpression(pattern: regexPattern)
            
            // NSRegularExpression에서 처리된 결과를 대체하는 함수
            let result = regex.stringByReplacingMatches(in: text, options: [], range: NSRange(text.startIndex..., in: text), withTemplate: "$1")
            return result
        } catch {
            return "Invalid regex pattern"
            
        }
        
    }
    
    func convertStringToInt(from string: String) -> Int {
        let cleanedString = string.components(separatedBy: CharacterSet(charactersIn: ",원")).joined()
        guard let IntNum = Int(cleanedString)
        else {
            print(#function)
            return 0
        }
        
        return IntNum
    }
    
}
