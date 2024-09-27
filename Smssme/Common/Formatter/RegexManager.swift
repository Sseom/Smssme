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
    
    func extractMatches(from text: String, using pattern: TextPattern) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: pattern.rawValue)
            let results = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("Invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    func extractDate(from text: String) -> String {
        return extractMatches(from: text, using: .date).first ?? "01/01"
    }
    
    func extractTime(from text: String) -> String {
        return extractMatches(from: text, using: .time).first ?? "00:00"
    }
    
    func extractAmount(from text: String) -> String {
        return extractMatches(from: text, using: .amount).first ?? "0원"
    }
    
    func extractContent(from text: String) -> String {
        return extractMatches(from: text, using: .content).first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "내용 없음"
    }
    
    //년월일 형식으로 변환
    func formatDateString(from text: String) -> String {
        let pattern1 = "(\\d{4})(\\d{2})(\\d{2})"     // 20240102
        let pattern2 = "(\\d{4})-(\\d{2})-(\\d{2})"   // 2024-01-02
        
        var regex1: NSRegularExpression?
        var regex2: NSRegularExpression?
        
        do {
            // 첫 번째 패턴 정규식 생성 시도
            regex1 = try NSRegularExpression(pattern: pattern1)
            // 두 번째 패턴 정규식 생성 시도
            regex2 = try NSRegularExpression(pattern: pattern2)
        } catch {
            // 정규식 생성 오류 처리
            print("정규식 생성 오류: \(error.localizedDescription)")
            return "날짜 형식이 잘못되었습니다"
        }
        
        var year: String?
        var month: String?
        var day: String?
        
        if let match = regex1?.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count)) {
            year = (text as NSString).substring(with: match.range(at: 1))
            month = (text as NSString).substring(with: match.range(at: 2))
            day = (text as NSString).substring(with: match.range(at: 3))
        }
        else if let match = regex2?.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count)) {
            year = (text as NSString).substring(with: match.range(at: 1))
            month = (text as NSString).substring(with: match.range(at: 2))
            day = (text as NSString).substring(with: match.range(at: 3))
        }
        
        if let year = year, let month = month, let day = day {
            return "\(year)년 \(month)월 \(day)일"
        }
        return "Invalid date format"
    }
    
    
    
}

enum TextPattern: String {
    
    case date = "\\d{2}/\\d{2}"
    case time = "\\d{2}:\\d{2}"
    case amount = "\\d{1,3}(,\\d{3})*원"
    case content = "\\b[\\w가-힣]+\\b"
}
