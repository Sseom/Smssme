//
//  FinancialPlanEditPlanVC.swift
//  Smssme
//
//  Created by 임혜정 on 9/2/24.
//

import UIKit

protocol FinancialPlanEditDelegate: AnyObject {
    func didUpdateFinacialPlan(_ plan: FinancialPlan)
}

class FinancialPlanEditPlanVC: UIViewController {
    weak var delegate: FinancialPlanEditDelegate?
    private var financialPlan: FinancialPlan
    private var financialPlanManager: FinancialPlanManager//유효값검사때
    private var createView: FinancialPlanCreateView
    
    init(financialPlanManager: FinancialPlanManager, textFieldArea: CreatePlanTextFieldView, financialPlan: FinancialPlan) { //dto가 필요하다..
        self.createView = FinancialPlanCreateView(textFieldArea: textFieldArea)
        self.financialPlanManager = financialPlanManager
        self.financialPlan = financialPlan
        super.init(nibName: nil, bundle: nil)
        
        setupInitialDate(with: financialPlan)
        setupDatePickerTarget()
        popularFields()
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
        view = createView
    }

    private func popularFields() {
        AmountTextField.setValue(for: createView.textFieldArea.targetAmountField, value: Int(financialPlan.amount))
        AmountTextField.setValue(for: createView.textFieldArea.currentSavedField, value: Int(financialPlan.deposit))
    }
}

// MARK: - 화면전환관련
extension FinancialPlanEditPlanVC {
    private func setupActions() {
        createView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
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
    private func setupInitialDate(with plan: FinancialPlan) {
        let 임시시작날짜 = Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 1))!
        let 임시종료날짜 = Calendar.current.date(from: DateComponents(year: 2025, month: 8, day: 31))!
        
        // 시작 날짜 설정
//        createView.textFieldArea.startDateField.text = FinancialPlanDateModel.dateFormatter.string(from: 임시시작날짜)
//        if let startDatePicker = createView.textFieldArea.startDateField.inputView as? UIDatePicker {
//            startDatePicker.date = 임시시작날짜
//        }
        
        if let startDate = plan.startDate {
            createView.textFieldArea.startDateField.text = FinancialPlanDateModel.dateFormatter.string(from: startDate)
        }
        
        
        
        // 종료 날짜 설정
        createView.textFieldArea.endDateField.text = FinancialPlanDateModel.dateFormatter.string(from: 임시종료날짜)
        if let endDatePicker = createView.textFieldArea.endDateField.inputView as? UIDatePicker {
            endDatePicker.date = 임시종료날짜
        }
    }
    
    private func setupDatePickerTarget() {
        if let startDatePicker = createView.textFieldArea.startDateField.inputView as? UIDatePicker {
            startDatePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        }
        if let endDatePicker = createView.textFieldArea.endDateField.inputView as? UIDatePicker {
            endDatePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        }
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        if sender == createView.textFieldArea.startDateField.inputView as? UIDatePicker {
            createView.textFieldArea.startDateField.text = FinancialPlanDateModel.dateFormatter.string(from: sender.date)
        } else if sender == createView.textFieldArea.endDateField.inputView as? UIDatePicker {
            createView.textFieldArea.endDateField.text = FinancialPlanDateModel.dateFormatter.string(from: sender.date)
        }
    }
}

// MARK: - 필드 입력값 유효성 검사
extension FinancialPlanEditPlanVC {
    private func validateAmount() -> Bool {
        guard let amountText = createView.textFieldArea.targetAmountField.text,
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
        guard let endDateString = createView.textFieldArea.endDateField.text,
                  let startDateString = createView.textFieldArea.startDateField.text,
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
