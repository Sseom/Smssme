//
//  DateManager.swift
//  Smssme
//
//  Created by KimRin on 9/3/24.
//

import UIKit

class DateManager {
    let calendar = Calendar.current
    
    func NumberOfDays() -> [Int] {
        var thisMonth: [Int] = []
        var lastMonth: [Int] = []
        var nextMonth: [Int] = []
        
        let totalMonth = lastMonth + thisMonth + nextMonth
        return totalMonth
    }
}
