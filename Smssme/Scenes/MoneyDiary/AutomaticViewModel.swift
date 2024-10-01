//
//  ViewModel.swift
//  Smssme
//
//  Created by KimRin on 10/1/24.
//

import Foundation
import RxSwift
import UIKit

class AutomaticViewModel {
    init() {}
    
    let state = PublishSubject<AutomaticEvent>()
    
    //event 가 들어와 케이스로 구분된 -> 이건 지금 어떠한 Action인지
    //근데 automatic Action에서는 케이스가 하나야 "저장한다" 라는
    func onAction(action: AutomaticAction) {

        //그 action을 가지고 어떻게 할거냐가 여기서부터 시작인거지
        switch action {
            //케이스가 저장한다밖에 없기에 한가지 케이스만 처리하는거지
            //여기서 action으 종류가 다양하다면 이부분에서 케이스를 추가처리하면 되는것이고
        case .onSave(let text):
            //그래서 저장한다라는것이 들어올때 text를 받아오는거야
            //이 부분에서는 textview에 있는 text를 받아올것이기때문에 왜냐고 ?
            //우리가 초기에 진행하려고 했던 케이스가 문자열을 받아와야 검증하고 검증한 내용에 따라서
            //view의 처리를 진행할것이기 때문이야.
            guard let text else {
                state.onNext(AutomaticEvent.onSaveFail("title","내용이 비어있어"))
                return
            }
            
            if(text.isEmpty){
                state.onNext(AutomaticEvent.onSaveFail("title","내용이 비어있어"))
                return
            }

            let transItem = extractPaymentDetails(from: text)
            if transItem.Amount == 0 {
                state.onNext(AutomaticEvent.onSaveFail(
                    "저장 실패", "100,000원 형식으로 작성해주세요."))
            } else {
                let time = DateManager.shared.transformDateWithoutTime(
                    date: transItem.transactionDate)
                let savedTimeString = DateFormatter.yearMonthDay.string(from: time)
                saveCurrentData(item: transItem)
                
                state.onNext(AutomaticEvent.onSaveComplete("저장 성공", "\(savedTimeString) 날짜에 저장되었습니다!"))
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

extension AutomaticViewModel{
    
    struct Input {
        let onSaveAction: Observable<Void>
    }
    
    struct Output {
        let validText: Observable<UIAlertController>
    }
}
