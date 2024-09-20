//
//  MoneyDiaryCreateVC.swift
//  Smssme
//
//  Created by 임혜정 on 9/5/24.
//

import CoreData
import UIKit

protocol MoneyDiaryCreationDelegate: AnyObject {
    func didCreateMoneyDiary(_ diary: Diary)
}

class MoneyDiaryCreationVC: UIViewController, UITextFieldDelegate {
    weak var creationDelegate: MoneyDiaryCreationDelegate?
    private let diaryManager: DiaryCoreDataManager
    var transactionItem: TransactionItem
    var transactionItem2: Diary
    
    //MARK: - Properties
    private let moneyDiaryEditView: MoneyDiaryEditView = MoneyDiaryEditView()
    
    // MARK: - ViewController Init
    init(diaryManager: DiaryCoreDataManager,transactionItem2: Diary) {
        self.diaryManager = diaryManager
        self.transactionItem = TransactionItem()
        self.transactionItem2 = transactionItem2
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addTarget()
        setupTextFields()
    }
    
    override func loadView() {
        super.loadView()
        self.view = moneyDiaryEditView
    }
    
    // MARK: - Method
    
    // MARK: - Private Method

    private func setupTextFields() {
        moneyDiaryEditView.priceTextField.delegate = self
        moneyDiaryEditView.categoryTextField.delegate = self
        moneyDiaryEditView.priceTextField.tag = 0
        moneyDiaryEditView.categoryTextField.tag = 1
    }
    
    //MARK: - Objc
    func addTarget() {
        moneyDiaryEditView.saveButton.addTarget(self, action: #selector(saveData), for: .touchUpInside)
        moneyDiaryEditView.cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        
    }
    
    @objc func saveData() {
        let date = moneyDiaryEditView.datePicker.date
        guard let amountText = moneyDiaryEditView.priceTextField.text,
              let amount = KoreanCurrencyFormatter.shared.number(from: amountText) else {
            showAlert(message: "올바른 금액을 입력해주세요.")
            return
        }
        
        let isIncome = moneyDiaryEditView.segmentControl.selectedSegmentIndex == 1
        let title = moneyDiaryEditView.titleTextField.text ?? ""
        let category = moneyDiaryEditView.categoryTextField.text
        let note = moneyDiaryEditView.noteTextView.text
        let memo = note == "메모" ? nil : note
        
        DiaryCoreDataManager.shared.createDiary(
            title: title,
            date: date,
            amount: amount,
            statement: isIncome,
            category: category,
            note: memo,
            userId: nil
        )
        
        // 저장된 데이터 확인
        let allDiaries = DiaryCoreDataManager.shared.fetchAllDiaries()
        print("현재 저장된 모든 다이어리:")
        for diary in allDiaries {
            print("제목: \(diary.title ?? ""), 날짜: \(diary.date ?? Date()), 금액: \(diary.amount), 수입/지출: \(diary.statement ? "수입" : "지출"), 카테고리: \(diary.category ?? ""), 메모: \(diary.note ?? ""), 사용자 ID: \(diary.userId ?? "")")
        }
        
        showAlert(message: "데이터가 성공적으로 저장되었습니다.") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }

    private func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
    
    
    @objc func didTapCancelButton() {
        self.navigationController?.popViewController(animated: false)
    }
}


// MARK: - 텍스트필드 한국화폐 표기
extension MoneyDiaryCreationVC {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag == 0 {
            if let currentText = textField.text,
               let textRange = Range(range, in: currentText) {
                let updatedText = currentText.replacingCharacters(in: textRange, with: string)
                let formattedText = KoreanCurrencyFormatter.shared.formatForEditing(updatedText)
                textField.text = formattedText
            }
            return false
        }
        return true

    }
    
    func showAlert(message: String, benefit: String) {
        let alertController = UIAlertController(title: "혜택 알림", message: message, preferredStyle: .alert)
        
        // "확인" 액션: 다른 ViewController로 전환
        let okAction = UIAlertAction(title: "확인하기", style: .default) { _ in
            let modalVc = UIViewController()
            modalVc.view = BenefitView(benefit: benefit)
            modalVc.modalPresentationStyle = .pageSheet
            
            
            if let sheet = modalVc.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
            }
            
            self.present(modalVc, animated: true, completion: nil)
        }
        
        // "취소" 액션: 알럿만 닫음
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        // 액션 추가
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // 알럿 표시
        present(alertController, animated: true, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let benefitcases = ["주거비", "의료비", "교육비", "보험료", "기부금"]
        // 사용자가 입력을 마치고 편집이 끝난 후 호출됨
        if let text = textField.text {
            // 입력된 값이 benefitcases 배열에 있는지 확인
            if benefitcases.contains(text) {
                // 배열에 있는 경우 해당 값을 textField에 유지 (필요시)
                textField.text = text
                // 알럿 표시
                showAlert(message: "받으실수있는 \(text) 혜택이 있어요!",benefit: text)
            }
        }
    }
}

