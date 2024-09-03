//
//  DateManager.swift
//  Smssme
//
//  Created by KimRin on 9/3/24.
//

import UIKit

class DateManager {
    let calendar = Calendar.current
    static let shared = DateManager()
    
    private init() {}
//    func dateTransformToString(date: Date) -> String {
//        var formatter = DateFormatter()
//        
//    }
    
    
    func NumberOfDays(yearMonth: Date) -> [Int] {
        let totalDaysCount = 42
        var thisMonth: [Int] = []
        var lastMonth: [Int] = []
        var nextMonth: [Int] = []
        
        let totalMonth = lastMonth + thisMonth + nextMonth
        return totalMonth
    }
    
    ///해당달의 마지막 숫자를 리턴 or nil
    func endOfDateNumber(month currentDateOfMonth: Date) -> Int? {
        guard let date = self.calendar.range(of: .day, in: .month, for: currentDateOfMonth)
        else { return nil }
        return date.count
    }
    
    func weekdayToString (month currentMonth: Date) -> Int {
        //Sun = 1 ...Sat: = 6
        return self.calendar.component(.weekday, from: currentMonth)
    }
    
    func navigateToMonth (to date: Date?) -> Date? {
        guard let safeDate = date 
        else { print(#function); return nil }
        let components = self.calendar.dateComponents([.year, .month], from: safeDate)
        return self.calendar.date(from: components)
    }
    
    
}
