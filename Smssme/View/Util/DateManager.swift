//
//  DateManager.swift
//  Smssme
//
//  Created by KimRin on 9/3/24.
//

import UIKit

class DateManager {
    var calendar = Calendar.current
    static let shared = DateManager()
    
    private init() {
        calendar.timeZone = TimeZone.init(secondsFromGMT: 9)!
    }
    
    
    func NumberOfDays(yearMonth: Date) -> [Date] {
        let totalDays = 42
        let total = [Date()]

        return total
    }
    
    ///해당달의 마지막 숫자를 리턴 or nil
    func endOfDateNumber(month currentDateOfMonth: Date) -> Int? {
        guard let date = self.calendar.range(of: .day, in: .month, for: currentDateOfMonth)
        else { return nil }
        return date.count
    }
    
    func weekdayToString (month currentMonth: Date) -> Int {
        return self.calendar.component(.weekday, from: currentMonth)
    }
    
    func navigateToMonth (to date: Date?) -> Date? {
        guard let safeDate = date 
        else { print(#function); return nil }
        let components = self.calendar.dateComponents([.year, .month], from: safeDate)
        return self.calendar.date(from: components)
    }
    
    
}
