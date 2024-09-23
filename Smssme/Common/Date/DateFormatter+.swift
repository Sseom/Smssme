//
//  DateFormatter+.swift
//  Smssme
//
//  Created by KimRin on 9/23/24.
//

import Foundation

extension DateFormatter {
   static let yearMonthDay: DateFormatter = {
       let formatter = DateFormatter()
       formatter.dateFormat = "yyyy-MM-dd"
       return formatter
   }()
   
   static let year: DateFormatter = {
       let formatter = DateFormatter()
       formatter.dateFormat = "yyyy"
       return formatter
   }()
   
   static let day: DateFormatter = {
       let formatter = DateFormatter()
       formatter.dateFormat = "dd"
       return formatter
   }()
   
   static let YMDHM: DateFormatter = {
       let formatter = DateFormatter()
       formatter.dateFormat = "yyyy-MM-dd HH:mm"
       return formatter
   }()
   
   static let yearMonth: DateFormatter = {
       let formatter = DateFormatter()
       formatter.dateFormat = "yyyy-MM"
       return formatter
   }()
   
   static let yearMonthKR: DateFormatter = {
       let formatter = DateFormatter()
       formatter.dateFormat = "yyyy년 MM월 "
       
       return formatter
   }()
}
