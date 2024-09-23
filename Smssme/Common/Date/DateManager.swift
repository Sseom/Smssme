//
//  DateManager.swift
//  Smssme
//
//  Created by KimRin on 9/3/24.
//

import UIKit

final class DateManager {
    var calendar = Calendar.current
    var dateComponents = DateComponents()
    static let shared = DateManager()
    private init() {
        self.dateComponents.timeZone = TimeZone(secondsFromGMT: 0)
    }

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
    
    func make000000(){
        self.dateComponents.hour = 0
        self.dateComponents.minute = 0
        self.dateComponents.second = 0
    }
    
    func make235959(){
        self.dateComponents.hour = 23
        self.dateComponents.minute = 59
        self.dateComponents.second = 59
    }
    
    
    
    func getlastDayInMonth(date: Date) -> Date {
        let lastDay = endOfMonthInDay(month: date)
        dateComponents.year = calendar.component(.year, from: date)
        dateComponents.month = calendar.component(.month, from: date)
        dateComponents.day = lastDay
        make235959()
        guard let lastDayInMonth = self.calendar.date(from: dateComponents)
        else {
            print(#function)
            return Date()}
        return lastDayInMonth
    }
    
    func getStartOfDayTime(date: Date) -> Date {
        let someday = calendar.component(.day, from: date)
        dateComponents.day = someday
        make000000()
        guard let startOfDay = self.calendar.date(from: dateComponents)
        else {
            print(#function)
            return Date()
        }
        return startOfDay
    }
    
    //
    func getEndofDayTime(date: Date) -> Date {
        let someday = calendar.component(.day, from: date)
        dateComponents.day = someday
        make235959()
        guard let endOfDay = self.calendar.date(from: dateComponents)
        else {
            print(#function)
            return Date()
        }
        return endOfDay
    }
    
    
    func moveToSomeday(when: Date, howLong: Int) -> Date {
        guard let temp = calendar.date(byAdding: DateComponents(day: howLong), to: when)
        else {
            print(#function)
            return Date()
        }
        return temp
    }
    
    //어떤달로의 이동
    func moveToSomeMonth(when: Date) -> Date{
        dateComponents = self.calendar.dateComponents([.year, .month], from: when)
        guard let date = self.calendar.date(from: dateComponents)
        else {
            print(#function)
            return Date()
        }
        return date
    }
    
    //해당달의 첫째날로 변환하기
    func getFirstDayInMonth(date: Date) -> Date {
        dateComponents.year = calendar.component(.year, from: date)
        dateComponents.month = calendar.component(.month, from: date)
        dateComponents.day = 1
        make000000()
        guard let temp = self.calendar.date(from: dateComponents)
        else {
            print(#function)
            return Date()}
        return temp
    }
    
    //해당달의 첫째날짜의 요일구하기
    func getFirstWeekday(for month: Date) -> Int {
        let currentMonth = getFirstDayInMonth(date: month)
        let weekdayValue = getWeekday(month: currentMonth)
        return weekdayValue
    }
    
    //해당달의 일자수 구하기
    func endOfMonthInDay(month: Date) -> Int {
        guard let date = self.calendar.range(of: .day, in: .month, for: month)
        else {
            print(#function)
            return 0 }
        return date.count // 28, 29, 30, 31
    }
    
    //요일구하기
    func getWeekday(month: Date) -> Int { // 그냥 요일임 그달의 요일이 아니라
        return self.calendar.component(.weekday, from: month)
    }
    
    
    
    //시간을 없애기
    func transformDateWithoutTime (date: Date) -> Date {
        dateComponents = self.calendar.dateComponents([.year, .month, .day], from: date)
        make000000()
        guard let dateWithoutTime = calendar.date(from: dateComponents)
        else {
            print(#function)
            return Date()
        }
        return dateWithoutTime
    }
    

    
    
    func daysBetween(start: Date, end: Date) -> Int? {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: start)
        let endOfDay = calendar.startOfDay(for: end)
        dateComponents = calendar.dateComponents([.day], from: startOfDay, to: endOfDay)
        return dateComponents.day
    }
}

