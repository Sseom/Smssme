//
//  FinancialPlanEditPlanVC.swift
//  Smssme
//
//  Created by 임혜정 on 9/2/24.
//

import UIKit

class FinancialPlanEditPlanVC: UIViewController {
    private var financialPlanManager: FinancialPlanManager
    private var financialPlanCreateView: FinancialPlanCreateView
    
    init(financialPlanManager: FinancialPlanManager, textFieldArea: CreatePlanTextFieldView) {
        self.financialPlanCreateView = FinancialPlanCreateView(textFieldArea: textFieldArea)
        self.financialPlanManager = financialPlanManager
        super.init(nibName: nil, bundle: nil)
        
        setupInitialDate()
        setupDatePickerTarget()
        AmountTextFieldConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupActions()
    }
    
    override func loadView() {
        view = financialPlanCreateView
    }
    
    private func AmountTextFieldConfigure() {
        let 목표금액임시값 = 1000000 // 사용자가 저장한 플랜의 값을 불러와야한다
        AmountTextField.setValue(for: financialPlanCreateView.textFieldArea.targetAmountField, value: 목표금액임시값)
        let 모은금액임시값 = 1000
        AmountTextField.setValue(for: financialPlanCreateView.textFieldArea.currentSavedField, value: 모은금액임시값)
    }
}

// MARK: - 화면전환관련
extension FinancialPlanEditPlanVC {
    private func setupActions() {
        financialPlanCreateView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    @objc func confirmButtonTapped() {
        if validateAmount() && validateEndDate() {
            let financialPlanCurrentPlanVC = FinancialPlanCurrentPlanVC()
            navigationController?.pushViewController(financialPlanCurrentPlanVC, animated: true)
        } else {
            print("입력값 오류")
        }
    }
}

extension FinancialPlanEditPlanVC {
    private func setupInitialDate() {
        let 임시시작날짜 = Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 1))!
        let 임시종료날짜 = Calendar.current.date(from: DateComponents(year: 2025, month: 8, day: 31))!
        
        // 시작 날짜 설정
        financialPlanCreateView.textFieldArea.startDateField.text = FinancialPlanDateModel.dateFormatter.string(from: 임시시작날짜)
        if let startDatePicker = financialPlanCreateView.textFieldArea.startDateField.inputView as? UIDatePicker {
            startDatePicker.date = 임시시작날짜
        }
        
        // 종료 날짜 설정
        financialPlanCreateView.textFieldArea.endDateField.text = FinancialPlanDateModel.dateFormatter.string(from: 임시종료날짜)
        if let endDatePicker = financialPlanCreateView.textFieldArea.endDateField.inputView as? UIDatePicker {
            endDatePicker.date = 임시종료날짜
        }
    }
    
    private func setupDatePickerTarget() {
        if let startDatePicker = financialPlanCreateView.textFieldArea.startDateField.inputView as? UIDatePicker {
            startDatePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        }
        if let endDatePicker = financialPlanCreateView.textFieldArea.endDateField.inputView as? UIDatePicker {
            endDatePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        }
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        if sender == financialPlanCreateView.textFieldArea.startDateField.inputView as? UIDatePicker {
            financialPlanCreateView.textFieldArea.startDateField.text = FinancialPlanDateModel.dateFormatter.string(from: sender.date)
        } else if sender == financialPlanCreateView.textFieldArea.endDateField.inputView as? UIDatePicker {
            financialPlanCreateView.textFieldArea.endDateField.text = FinancialPlanDateModel.dateFormatter.string(from: sender.date)
        }
    }
}

// MARK: - 필드 입력값 유효성 검사
extension FinancialPlanEditPlanVC {
    private func validateAmount() -> Bool {
        guard let amountText = financialPlanCreateView.textFieldArea.targetAmountField.text,
              let amount = Int64(amountText) else {
//            financialPlanCreateView.textFieldArea.targetAmountField.text = "유효한 금액을 입력하세요"
            print("양수여야 합니다")
            return false
        }
        
        do {
            try financialPlanManager.validateAmount(amount)
            return true
        } catch {
            print("양수여야 합니다")
            return false
        }
    }
    
    private func validateEndDate() -> Bool {
        guard let endDateString = financialPlanCreateView.textFieldArea.endDateField.text,
                  let startDateString = financialPlanCreateView.textFieldArea.startDateField.text,
                  let endDate = FinancialPlanDateModel.dateFormatter.date(from: endDateString),
                  let startDate = FinancialPlanDateModel.dateFormatter.date(from: startDateString) else {
                print("날짜 형식이 올바르지 않습니다")
                return false
            }
        do {
            try financialPlanManager.validateDates(start: startDate, end: endDate)
            return true
        } catch {
            print("안돼요")
            return false
        }
    }
}
