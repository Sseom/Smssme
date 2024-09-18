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
        if let currentText = textField.text,
           let textRange = Range(range, in: currentText) {
            let updatedText = currentText.replacingCharacters(in: textRange, with: string)
            let formattedText = KoreanCurrencyFormatter.shared.formatForEditing(updatedText)
            textField.text = formattedText
        }
        return false
    }
}
