//
//  AutomaticTransactionVC.swift
//  Smssme
//
//  Created by KimRin on 9/12/24.
//

import UIKit
import SnapKit

class AutomaticTransactionVC: UIViewController {
    private let automaticView = AutomaticTransactionView()
    var transactionItem = TransactionItem()
    override func viewDidLoad() {
        super.viewDidLoad()
        addTarget()
        view.addSubview(automaticView)
        self.automaticView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func addTarget() {
        automaticView.submitButton.addTarget(self, action: #selector(saveData), for: .touchUpInside)
    }
    
    
    
    
    
    @objc func saveData() {
        if let text = automaticView.inputTextView.text {
            let temp = extractPaymentDetails(from: text)
            saveCurrentData()
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

    // 결제 세부사항을 추출하는 함수
    func extractPaymentDetails(from text: String) -> TransactionItem{

        let datePattern = "\\d{2}/\\d{2}"
        let dateString = extractMatches(from: text, using: datePattern).first ?? "결제날짜 없음"
        
        // 2. 결제 시간 추출
        let timePattern = "\\d{2}:\\d{2}"
        let timeString = extractMatches(from: text, using: timePattern).first ?? "11:11"
        
        // 3. 결제 금액 추출
        let amountPattern = "\\d{1,3}(,\\d{3})*원" // 금액 추출
        let amountString = extractMatches(from: text, using: amountPattern).first ?? "결제금액 없음"
        
        // 4. 결제 내용 추출 (결제 시간과 결제 금액 이후의 첫 번째 단어를 추출)
        var remainingText = text
        
        // 결제 시간과 결제 금액 뒤에 남은 텍스트를 추출
        if let timeRange = text.range(of: timeString) {
            remainingText = String(text[timeRange.upperBound...]).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        if let amountRange = remainingText.range(of: amountString) {
            remainingText = String(remainingText[amountRange.upperBound...]).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        // 결제내용에서 첫 번째 의미 있는 단어를 추출
        let contentPattern = "\\b[\\w가-힣]+\\b"
        let contentString = extractMatches(from: remainingText, using: contentPattern).first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "결제내용 없음"

        
        let amount = convertStringToInt(from: amountString) ?? 0
        let date: Date = makeDate(date: dateString, time: timeString)
        let title = contentString

        transactionItem = TransactionItem(name: title,
                                          Amount: amount,
                                          isIncom: false,
                                          transactionDate: date,
                                          memo: text
        )

        print(transactionItem.name,transactionItem.Amount,transactionItem.transactionDate)
        
        return transactionItem
    }
    
    
    func convertStringToInt(from string: String) -> Int? {
        // "원" 및 쉼표 제거
        let cleanedString = string.components(separatedBy: CharacterSet(charactersIn: ",원")).joined()
        return Int(cleanedString)
    }
    
    func makeDate(date:String, time: String?) -> Date {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        var selectedMonthDay = date
        let selectedTime = time ?? "11:11"
        
        selectedMonthDay.replace(at: 2, with: "-")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let thistime = "\(currentYear)-\(selectedMonthDay) \(selectedTime)"
        
        let savetime = dateFormatter.date(from: thistime) ?? Date()
        return savetime
    }
    
    @objc func saveCurrentData() {
        let date = transactionItem.transactionDate
        let amount = Int64(transactionItem.Amount)
        let statement = transactionItem.isIncom
      
        let titleTextField = transactionItem.name
        let categoryTextField = ""
        let memo = transactionItem.memo
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

