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
    /*
     한국시간을 적용하고싶지만 뽑아내는 시간자체가 UTC로 옵니다
     즉 한국시간의 09-01-16:00 +0900 인  KST로 저장을해도
     이값이 전달되는게 아니라
     그 값을 변환한서 -9시간된 09-01-09:00 +0000 인
     utc값으로 주더라구요
     기준을 utc로 설정했습니다. 참고하세요
     또한 Date타입은 시간을 항상 동반합니다
     */
    private init() {}

    func configureDays (currentMonth: Date) -> [Date] {
        var totalDays: [Date] = []
        let firstDayInMonth = getFirstDayInMonth(date: currentMonth)
        let firstWeekday = getFirstWeekday(for: currentMonth)
        let lastMonthOfStart = moveToSomeday(when: firstDayInMonth, howLong: -firstWeekday + 1)
        for i in 0 ..< 42 {
                totalDays.append(moveToSomeday(when: lastMonthOfStart, howLong: i))
            }
        return totalDays
    }
    
    
    func getlastDayInMonth(date: Date) -> Date {
        let lastDay = endOfDateNumber(month: date)
        var dateComponents = DateComponents()
        dateComponents.year = calendar.component(.year, from: date)
        dateComponents.month = calendar.component(.month, from: date)
        dateComponents.day = lastDay
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        dateComponents.timeZone = TimeZone(secondsFromGMT: 0)
        guard let temp = self.calendar.date(from: dateComponents)
        else {
            print(#function)
            return Date()}
        return temp
    }
    
    
    func moveToSomeday(when: Date, howLong: Int) -> Date {
        guard let temp = calendar.date(byAdding: DateComponents(day: howLong), to: when)
        else {
            print(#function)
            return Date()
        }
        return temp
    }
    
    func getFirstDayInMonth(date: Date) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = calendar.component(.year, from: date)
        dateComponents.month = calendar.component(.month, from: date)
        dateComponents.day = 1
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        dateComponents.timeZone = TimeZone(secondsFromGMT: 0)
        guard let temp = self.calendar.date(from: dateComponents)
        else {
            print(#function)
            return Date()}
        return temp
    }
    
    
    func getFirstWeekday(for month: Date) -> Int{
        let temp = getFirstDayInMonth(date: month)
        let temp2 = calendar.component(.weekday, from: temp)
        return temp2
    }
    
    
    func endOfDateNumber(month currentDateOfMonth: Date) -> Int {
        guard let date = self.calendar.range(of: .day, in: .month, for: currentDateOfMonth)
        else {
            print(#function)
            return 0 }
        return date.count
    }
    
    func getWeekdayNum(month currentMonth: Date) -> Int { // 그냥 요일임 그달의 요일이 아니라
        return self.calendar.component(.weekday, from: currentMonth)
    }
    
    
    
    func transformDateWithoutTime (date: Date) -> Date {
        var components = self.calendar.dateComponents([.year, .month, .day], from: date)
        components.hour = 0
        components.minute = 0
        components.second = 0
        components.timeZone = TimeZone(secondsFromGMT: 0)
        guard let dateWithoutTime = calendar.date(from: components)
        else {
            print(#function)
            return Date()
        }
        return dateWithoutTime
    }
    
    func moveToSomeMonth(when: Date) -> Date{
        let components = self.calendar.dateComponents([.year, .month], from: when)
        guard let date = self.calendar.date(from: components)
        else {
            print(#function)
            return Date()
        }
        
        return date
    }
    
    
}
