//
//  AutomaticTransactionVC.swift
//  Smssme
//
//  Created by KimRin on 9/12/24.
//코드검토 (2024.09.15)// 정규표현식 이해의 대한 어려움
//어떻게 풀어서 쓸것이며 어떻게 더 정확히 값을 뽑아낼수있을까 

import UIKit
import SnapKit

class AutomaticTransactionVC: UIViewController {
    private let automaticView = AutomaticTransactionView()
    
    var transactionItem = TransactionItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        [
            automaticView
        ].forEach { view.addSubview($0) }
        //사용방법 버튼 구성?
        self.automaticView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        automaticView.submitButton.addTarget(self, action: #selector(saveData), for: .touchUpInside)
        automaticView.howToUseButton.addTarget(self, action: #selector(showHowToUseView), for: .touchUpInside)
    }
    
    @objc func showHowToUseView() {
        
    }

    @objc func saveData() {
        if let text = automaticView.inputTextView.text {
            
                self.transactionItem = extractPaymentDetails(from: text)
                saveCurrentData(item: self.transactionItem)
            
            
        }
        self.navigationController?.popViewController(animated: false)
        
    }
    
    func extractMatches(from text: String, using pattern: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let results = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("Invalid regex: \(error.localizedDescription)")
            return []
        }
    }


    func extractPaymentDetails(from text: String) -> TransactionItem{
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
        
        transactionItem = TransactionItem(name: titleString,
                                          Amount: amount,
                                          isIncom: false,
                                          transactionDate: date,
                                          memo: text
        )
        return transactionItem
    }
    
    

    
    func makeDate(date:String, time: String?) -> Date {
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
        self.navigationController?.popViewController(animated: false)
        
    }
}

extension String {
    mutating func replace(at index: Int, with newChar: Character) {
        // 문자열의 인덱스를 계산
        let stringIndex = self.index(self.startIndex, offsetBy: index)
        
        // 기존 문자열을 배열로 변환하여 문자 교체
        self.replaceSubrange(stringIndex...stringIndex, with: String(newChar))
    }
}

