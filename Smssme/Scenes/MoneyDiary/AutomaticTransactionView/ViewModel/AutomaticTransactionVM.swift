//
//  AutomaticViewModel.swift
//  Smssme
//
//  Created by KimRin on 10/4/24.
//

import Foundation
import RxSwift
import UIKit

enum AutomaticTransactionAction {
    case onsave(String?)

}

enum AutomaticTransactionEvent {
    case onSaveComplete(String, String)
    case onSaveFail(String, String)
}


class AutomaticTransactionVM {
    
    struct Input {
        let tap: Observable<String?>
    }
    struct Output {
        let event: Observable<(title: String, message: String, isComplete: Bool)>
    }
    let disposedBag = DisposeBag()
    

    init() {}
    
    func transform(_ input: Input) -> Output {
        let eventSubject = PublishSubject<(title: String, message: String, isComplete: Bool)>()
        
        input.tap.subscribe(onNext: { [weak self] text in
            self?.handleSave(text: text, eventSubject: eventSubject)
            
        })
        .disposed(by: disposedBag)
        
        return .init(event: eventSubject.asObservable())
    }
                            
    private func handleSave(text: String?, eventSubject: PublishSubject<(title: String, message: String, isComplete: Bool)>) {
           guard let text, !text.isEmpty else {
               eventSubject.onNext(("저장 실패", "내용이 비어있습니다.", false))
               return
           }
           
           let transactionItem = extractPaymentDetails(from: text)
           
           if transactionItem.Amount == 0 {
               eventSubject.onNext(("저장 실패", "금액을 찾을 수 없습니다.", false))
           } else {
               let time = DateManager.shared.transformDateWithoutTime(date: transactionItem.transactionDate)
               let savedTimeString = DateFormatter.yearMonthDay.string(from: time)
               saveCurrentData(item: transactionItem)
               eventSubject.onNext(("저장 성공", "\(savedTimeString) 날짜에 저장되었습니다", true))
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
