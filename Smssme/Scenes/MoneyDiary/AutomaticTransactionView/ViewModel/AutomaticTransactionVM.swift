//
//  AutomaticViewModel.swift
//  Smssme
//
//  Created by KimRin on 10/4/24.
//

import Foundation
import RxSwift
import UIKit

class AutomaticTransactionVM {
    init() {}
    
    //일단 첫째로 어떤 액션이 있고 어떠한 뷰의 이벤트가 있냐가 포인트 !
    let event = PublishSubject<AutomaticTransactionEvent>()
    
    func onAction(action: AutomaticTransactionAction) {
       
        switch action{

        case .onsave(let text):
            guard let text,
                  !text.isEmpty
            
            else {
                event.onNext(AutomaticTransactionEvent.onSaveFail("저장실패", "내용이 비어있습니다."))
                return
            }
            
            let transactionItem = extractPaymentDetails(from: text)
            
            if transactionItem.Amount == 0 {
                event.onNext(AutomaticTransactionEvent.onSaveFail("저장실패", "금액을 찾을수없습니다."))
                
            } else {
                
                let time = DateManager.shared.transformDateWithoutTime(date: transactionItem.transactionDate)
                
                let savedTimeString = DateFormatter.yearMonthDay.string(from: time)
                saveCurrentData(item: transactionItem)
                
                event.onNext(AutomaticTransactionEvent.onSaveComplete("저장성공", "\(savedTimeString) 날짜에 저장되었습니다"))
            }
            
            
        }
    }
    
    private func extractPaymentDetails(from text: String) -> TransactionItem{
        let dateString = RegexManager.shared.extractDate(from: text)
        let timeString = RegexManager.shared.extractTime(from: text)
        let amountString = RegexManager.shared.extractAmount(from: text)
        let titleString = RegexManager.shared.extractContent(from: text)
        
        var remainingText = text
        
        if let timeRange = text.range(of: timeString) {
            remainingText = String(text[timeRange.upperBound...]).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if let amountRange = remainingText.range(of: amountString) {
            remainingText = String(remainingText[amountRange.upperBound...]).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        let amount = RegexManager.shared.convertStringToInt(from: amountString)
        let date: Date = makeDate(date: dateString, time: timeString)
        
        
        return TransactionItem(name: titleString,
                               Amount: amount,
                               isIncom: false,
                               transactionDate: date,
                               memo: text)
    }
    
    private func makeDate(date:String, time: String?) -> Date {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        var selectedMonthDay = date
        let selectedTime = time ?? "11:11"
        
        selectedMonthDay.replace(at: 2, with: "-")
        
        let dateFormatter = DateFormatter.YMDHM
        dateFormatter.timeZone = TimeZone.init(secondsFromGMT: 32400)
        
        let thistime = "\(currentYear)-\(selectedMonthDay) \(selectedTime)"
        
        let savetime = dateFormatter.date(from: thistime) ?? Date()
        
        return savetime
    }
    
    func saveCurrentData(item: TransactionItem) {
        
        let date = item.transactionDate
        let amount = Int64(item.Amount)
        let statement = item.isIncom
        let titleTextField = item.name
        let categoryTextField = ""
        let memo = item.memo
        
        DiaryCoreDataManager.shared.createDiary(title: titleTextField, date: date, amount: amount, statement: statement, category: categoryTextField, note: memo, userId: "userKim")
        
    }
    
    
    
    
}
