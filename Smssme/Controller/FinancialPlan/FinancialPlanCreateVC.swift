//
//  FinancialPlanCreateVC.swift
//  Smssme
//
//  Created by 임혜정 on 8/27/24.
//

import CoreData
import UIKit

protocol FinancialPlanCreationDelegate: AnyObject {
    func didCreateFinancialPlan(_ plan: FinancialPlan)
}

class FinancialPlanCreateVC: UIViewController, UITextFieldDelegate {
    weak var creationDelegate: FinancialPlanCreationDelegate?
    private var financialPlanManager: FinancialPlanManager
    private var createView: FinancialPlanCreateView
    private let repository: FinancialPlanRepository
    private let selectedPlan: PlanItem
    
    init(financialPlanManager: FinancialPlanManager, textFieldArea: CreatePlanTextFieldView, selectedPlan: PlanItem, repository: FinancialPlanRepository) {
        self.createView = FinancialPlanCreateView(textFieldArea: textFieldArea)
        self.financialPlanManager = financialPlanManager
        self.selectedPlan = selectedPlan
        self.repository = repository
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
        setupTextFields()
    }
    
    override func loadView() {
        view = createView
    }
    
    private func setupUI() {
        createView.planCreateTitle.text = selectedPlan.title
    }
    
    private func setupTextFields() {
        createView.textFieldArea.targetAmountField.delegate = self
        createView.textFieldArea.currentSavedField.delegate = self
    }
}

// MARK: - 화면전환관련
extension FinancialPlanCreateVC {
    private func setupActions() {
        createView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    @objc func confirmButtonTapped() {
        if validateInputs() {
            buttonTapSaveData()
            let tabBar = TabBarController()
            
            tabBar.selectedIndex = 2
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = tabBar
                window.makeKeyAndVisible()
            }
        } else {
            print("입력값 오류")
        }
    }
    
    private func validateInputs() -> Bool {
        return validateAmount() && validateEndDate()
    }
}

extension FinancialPlanCreateVC {
    private func setupInitialDate() {
        let today = Date()
        createView.textFieldArea.startDateField.text = FinancialPlanDateModel.dateFormatter.string(from: today)
        createView.textFieldArea.endDateField.text = FinancialPlanDateModel.dateFormatter.string(from: today)
        
        if let startDatePicker = createView.textFieldArea.startDateField.inputView as? UIDatePicker {
            startDatePicker.date = today
        }
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

extension FinancialPlanCreateVC {
    func buttonTapSaveData() -> FinancialPlan? {
        guard let amountText = createView.textFieldArea.targetAmountField.text,
              let amount = KoreanCurrencyFormatter.shared.number(from: amountText),
              let depositText = createView.textFieldArea.currentSavedField.text,
              let deposit = KoreanCurrencyFormatter.shared.number(from: depositText),
              let startDate = FinancialPlanDateModel.dateFormatter.date(from: createView.textFieldArea.startDateField.text ?? ""),
              let endDate = FinancialPlanDateModel.dateFormatter.date(from: createView.textFieldArea.endDateField.text ?? "") else {
            showAlert(message: "모든 필드를 올바르게 입력해주세요.")
            return nil
        }
        
        do {
            try financialPlanManager.validateAmount(amount)
            try financialPlanManager.validateDeposit(deposit)
            try financialPlanManager.validateDates(start: startDate, end: endDate)
            
            let newPlan = repository.createFinancialPlan(
                title: selectedPlan.title,
                amount: amount,
                deposit: deposit,
                startDate: startDate,
                endDate: endDate
            )
            
            print("새로운 계획이 저장되었습니다: \(newPlan)")
            repository.printFinancialPlan(withId: newPlan.id)
            repository.printAllFinancialPlans()
            return newPlan
        } catch {
            showAlert(message: "계획 저장 실패: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - 필드 입력값 유효성 검사
extension FinancialPlanCreateVC {
    private func validateAmount() -> Bool {
        guard let amountText = createView.textFieldArea.targetAmountField.text,
              !amountText.isEmpty else {
            showAlert(message: "목표 금액을 입력해주세요.")
            return false
        }
        
        guard let amount = KoreanCurrencyFormatter.shared.number(from: amountText) else {
            showAlert(message: "올바른 금액 형식이 아닙니다.")
            return false
        }
        
        do {
            try financialPlanManager.validateAmount(amount)
            return true
        } catch ValidationError.negativeAmount {
            showAlert(message: "목표 금액은 0보다 커야 합니다.")
            return false
        } catch {
            showAlert(message: "금액 검증 중 오류가 발생했습니다.")
            return false
        }
    }
    
    private func validateEndDate() -> Bool {
        guard let endDateString = createView.textFieldArea.endDateField.text,
              let startDateString = createView.textFieldArea.startDateField.text,
              let endDate = FinancialPlanDateModel.dateFormatter.date(from: endDateString),
              let startDate = FinancialPlanDateModel.dateFormatter.date(from: startDateString) else {
            showAlert(message: "올바른 날짜 형식이 아닙니다.")
            return false
        }
        do {
            try financialPlanManager.validateDates(start: startDate, end: endDate)
            return true
        } catch {
            showAlert(message: "종료 날짜는 시작 날짜보다 늦어야 합니다.")
            return false
        }
    }
}

// MARK: - 텍스트필드 한국화폐 표기
extension FinancialPlanCreateVC {
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

