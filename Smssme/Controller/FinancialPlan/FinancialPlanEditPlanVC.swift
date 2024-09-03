//
//  FinancialPlanEditPlanVC.swift
//  Smssme
//
//  Created by 임혜정 on 9/2/24.
//

import UIKit

class FinancialPlanEditPlanVC: UIViewController {
    private var financialPlanCreateView: FinancialPlanCreateView
    private var textField: CustomTextField
    private var datePicker: UIDatePicker
    
    init(textFieldArea: CreatePlanTextFieldView) {
        self.financialPlanCreateView = FinancialPlanCreateView(textFieldArea: textFieldArea)
        textField = GoalDateTextField.createTextField()
        datePicker = GoalDateTextField.createDatePicker()
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
        let financialPlanConfirmVC = FinancialPlanConfirmVC()
        navigationController?.pushViewController(financialPlanConfirmVC, animated: true)
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
        textField.text = FinancialPlanDateModel.dateFormatter.string(from: sender.date)
    }
}
