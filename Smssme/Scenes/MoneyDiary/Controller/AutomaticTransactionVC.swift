//
//  AutomaticTransactionVC.swift
//  Smssme
//
//  Created by KimRin on 9/12/24.
//코드검토 (2024.09.15)// 정규표현식 이해의 대한 어려움
//어떻게 풀어서 쓸것이며 어떻게 더 정확히 값을 뽑아낼수있을까 

import UIKit
import SnapKit
//
class AutomaticTransactionVC: UIViewController {
    private let automaticView = AutomaticTransactionView()
    
    var transactionItem = TransactionItem() // out
    
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
            $0.edges.equalToSuperview()
        }
        
        automaticView.submitButton.addTarget(self, action: #selector(saveData), for: .touchUpInside)
       
    }
    


    @objc func saveData() {
        if let text = automaticView.inputTextView.text {
            
                self.transactionItem = extractPaymentDetails(from: text)
            
            let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default) { _ in
                self.dismiss(animated: true)
            }
            alertController.addAction(okAction)
            if transactionItem.Amount == 0 {
                alertController.title = "저장 실패"
                alertController.message = "100,000원 형식으로 작성해주세요."
            }
            else{
                let time = DateManager.shared.transformDateWithoutTime(
                    date: transactionItem.transactionDate)
                let savedTimeString = DateFormatter.yearMonthDay.string(from: time)
                saveCurrentData(item: self.transactionItem)
                alertController.title = "저장 성공"
                
                alertController.message = "\(savedTimeString) 날짜에 저장되었습니다!"
            }

            present(alertController, animated: true, completion: nil)

        }
        
        
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
    

    func showAlert() {
        
 
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
    
    
    struct 입력 //Input
    {//버튼누르기
        //transaction viewmodel에서 처리
        
    }
    struct 출력 // OUTPUT 
    {
        //alert을 보여준다 성/실 -> 공통된UI의 text다른차이뿐 -> 전달해서 alert으로 output을 보낸다.
        //성공시 ->데이터저장 후. 얼럿 -> ㄴㅅㅁㅅㄷrk 퍄냐ㅠㅣㄷ ㅐㄱ ㅜㅐㅅ
        /* 뷰 입력 -> 출력 입력에 의해서 뷰의 상태의 변경?  화면 보여줄게 알럿뿐
         버튼누르기가 들어왓다 인풋들어옴 로직처리 -> 아웃이 나간다
         텍스트필드에 택스트를 가져와야함 -> 그런후 로직처리
         검증 처리
         실패시 -> 알럿 // 실패스트링 // 얼럿을 아웃풋으로 vc에 던지고 vc에서 얼럿을띄워줌
         성공시 -> 저장//코어데이터로 // 얼럿을 아웃풋으로 성공스트링과 던진다.
         ......................
         */
    }
}

