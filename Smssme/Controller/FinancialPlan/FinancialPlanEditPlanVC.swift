//
//  FinancialPlanEditPlanVC.swift
//  Smssme
//
//  Created by 임혜정 on 9/2/24.
//

import UIKit

protocol FinancialPlanEditDelegate: AnyObject {
    func didUpdateFinancialPlan(_ plan: FinancialPlanDTO)
}

class FinancialPlanEditPlanVC: UIViewController, UITextFieldDelegate {
    weak var editDelegate: FinancialPlanEditDelegate?
    private var createView: FinancialPlanCreateView = FinancialPlanCreateView(textFieldArea: CreatePlanTextFieldView())
    private var planService: FinancialPlanService
    private var planDTO: FinancialPlanDTO
    
    init(planService: FinancialPlanService, planDTO: FinancialPlanDTO) {
        self.planService = planService
        self.planDTO = planDTO
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupActions()
        configure(with: planDTO)
        setupDatePickerTarget()
        setupTextFields()
    }
    
    override func loadView() {
        view = createView
    }
}

// MARK: - 화면전환관련
extension FinancialPlanEditPlanVC {
    private func setupActions() {
        createView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    @objc func confirmButtonTapped() {
        if validateInputs() {
            saveUpdatedPlan()
        } else {
            showAlert(message: "입력값을 확인해주세요")
        }
    }
    
    private func validateInputs() -> Bool {
        return validateAmount() && validateAmount()
    }
    
    private func saveUpdatedPlan() {
        guard let amountText = createView.textFieldArea.targetAmountField.text,
              let amount = KoreanCurrencyFormatter.shared.number(from: amountText),
              let depositText = createView.textFieldArea.currentSavedField.text,
              let deposit = KoreanCurrencyFormatter.shared.number(from: depositText),
              let startDateString = createView.textFieldArea.startDateField.text,
              let endDateString = createView.textFieldArea.endDateField.text,
              let startDate = FinancialPlanDateModel.dateFormatter.date(from: startDateString),
              let endDate = FinancialPlanDateModel.dateFormatter.date(from: endDateString) else {
            print("해결중 에러")
            return
        }
        
        do {
            let updateDTO = FinancialPlanDTO(
                id: planDTO.id,
                title: planDTO.title,
                amount: amount,
                deposit: deposit,
                startDate: startDate,
                endDate: endDate,
                planType: planDTO.planType,
                isCompleted: false
            )
            
            try planService.updateFinancialPlan(updateDTO)
            editDelegate?.didUpdateFinancialPlan(updateDTO)
            
            showAlert(message: "계획이 성공적으로 업데이트되었습니다.") { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        } catch {
            showAlert(message: "목표날짜는 시작날짜 이후여야합니다")
        }
    }
    
    private func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
}

extension FinancialPlanEditPlanVC {
    private func configure(with plan: FinancialPlanDTO) {
        createView.textFieldArea.targetAmountField.text = "\(plan.amount.formattedAsCurrency)"
        createView.textFieldArea.currentSavedField.text = "\(plan.deposit.formattedAsCurrency)"
        createView.textFieldArea.startDateField.text = "\(FinancialPlanDateModel.dateFormatter.string(from: plan.startDate))"
        createView.textFieldArea.endDateField.text = "\(FinancialPlanDateModel.dateFormatter.string(from: plan.endDate))"
    }
    
    private func setupDatePickerTarget() {
        if let startDatePicker = createView.textFieldArea.startDateField.inputView as? UIDatePicker {
            startDatePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        }
        if let endDatePicker = createView.textFieldArea.endDateField.inputView as? UIDatePicker {
            endDatePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        }
    }
    private func setupTextFields() {
        createView.textFieldArea.targetAmountField.delegate = self
        createView.textFieldArea.currentSavedField.delegate = self
        
        // 초기 값 설정
        createView.textFieldArea.targetAmountField.text = planDTO.amount.formattedAsCurrency
        createView.textFieldArea.currentSavedField.text = planDTO.deposit.formattedAsCurrency
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let currentText = textField.text,
           let textRange = Range(range, in: currentText) {
            let updatedText = currentText.replacingCharacters(in: textRange, with: string)
            let formattedText = KoreanCurrencyFormatter.shared.formatForEditing(updatedText)
            textField.text = formattedText
            
            // int 값 저장
            if textField == createView.textFieldArea.targetAmountField {
                planDTO.amount = KoreanCurrencyFormatter.shared.number(from: formattedText) ?? 0
            } else if textField == createView.textFieldArea.currentSavedField {
                planDTO.deposit = KoreanCurrencyFormatter.shared.number(from: formattedText) ?? 0
            }
        }
        return false
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
              !amountText.isEmpty else {
            showAlert(message: "금액을 입력해주세요.")
            return false
        }
        
        guard let amount = KoreanCurrencyFormatter.shared.number(from: amountText) else {
            showAlert(message: "올바른 금액 형식이 아닙니다.")
            return false
        }
        
        do {
            try planService.validateAmount(amount)
            return true
        } catch ValidationError.negativeAmount {
            showAlert(message: "금액은 0보다 커야 합니다.")
            return false
        } catch {
            showAlert(message: "금액 검증 중 오류가 발생했습니다.")
            return false
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func validateEndDate() -> Bool {
        guard let endDateString = createView.textFieldArea.endDateField.text,
              let startDateString = createView.textFieldArea.startDateField.text,
              let endDate = FinancialPlanDateModel.dateFormatter.date(from: endDateString),
              let startDate = FinancialPlanDateModel.dateFormatter.date(from: startDateString) else {
            return false
        }
        do {
            try planService.validateDates(start: startDate, end: endDate)
            return true
        } catch {
            return false
        }
    }
}

