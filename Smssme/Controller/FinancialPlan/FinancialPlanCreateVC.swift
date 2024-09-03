//
//  FinancialPlanCreateVC.swift
//  Smssme
//
//  Created by 임혜정 on 8/27/24.
//

import UIKit
import CoreData

class FinancialPlanCreateVC: UIViewController {
    private var financialPlanManager: FinancialPlanManager
    private var createView: FinancialPlanCreateView
    //    private let textFieldArea: CreatePlanTextFieldView
    private let repository = FinancialPlanRepository()
    private let selectedPlan: PlanItem
    
    
    init(financialPlanManager: FinancialPlanManager, textFieldArea: CreatePlanTextFieldView, selectedPlan: PlanItem) {
        self.createView = FinancialPlanCreateView(textFieldArea: textFieldArea)
        self.financialPlanManager = financialPlanManager
        self.selectedPlan = selectedPlan
        super.init(nibName: nil, bundle: nil)
        
        setupInitialDate()
        setupDatePickerTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupActions()
        setupUI()
    }
    
    override func loadView() {
        view = createView
    }
    
    private func setupUI() {
        createView.planCreateTitle.text = selectedPlan.title
    }
}

// MARK: - 화면전환관련
extension FinancialPlanCreateVC {
    private func setupActions() {
        createView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    @objc func confirmButtonTapped() {
        if validateAmount() && validateEndDate() {
            buttonTapSaveData()
            let financialPlanCurrentPlanVC = FinancialPlanCurrentPlanVC()
            navigationController?.pushViewController(financialPlanCurrentPlanVC, animated: true)
        } else {
            print("입력값 오류")
        }
    }
}

extension FinancialPlanCreateVC {
    private func setupInitialDate() {
        // 시작 날짜 설정
        let today = Date()
        createView.textFieldArea.startDateField.text = FinancialPlanDateModel.dateFormatter.string(from: today)
        if let startDatePicker = createView.textFieldArea.startDateField.inputView as? UIDatePicker {
            startDatePicker.date = today
        }
        
        // 종료 날짜 설정
        createView.textFieldArea.endDateField.text = FinancialPlanDateModel.dateFormatter.string(from: today)
        if let endDatePicker = createView.textFieldArea.endDateField.inputView as? UIDatePicker {
            endDatePicker.date = today
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
extension FinancialPlanCreateVC {
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

extension FinancialPlanCreateVC {
    
    func buttonTapSaveData() {
        guard let amountText = createView.textFieldArea.targetAmountField.text,
              let amount = Int64(amountText),
              let depositText = createView.textFieldArea.currentSavedField.text,
              let deposit = Int64(depositText),
              let startDate = createView.textFieldArea.startDateField.date,
              let endDate = createView.textFieldArea.endDateField.date else {
            // 오류 처리
            return
        }
        
        do {
            try financialPlanManager.validateAmount(amount)
            try financialPlanManager.validateDeposit(deposit)
            try financialPlanManager.validateDates(start: startDate, end: endDate)
            
            let newPlan = repository.createFinancialPlan(
                title: selectedPlan.title,
                amount: amount,
                deposit: deposit, // 초기 저축액은 0으로 설정
                startDate: startDate,
                endDate: endDate
            )
            
            print("새로운 계획이 저장되었습니다: \(newPlan)")
            repository.printFinancialPlan(withId: newPlan.id)
            repository.printAllFinancialPlans()
            navigationController?.popViewController(animated: true)
        } catch {
            // 오류 처리
            print("Failed to save financial plan: \(error)")
        }
    }
    
}
