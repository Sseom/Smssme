//
//  FinancialPlanCreateVC.swift
//  Smssme
//
//  Created by 임혜정 on 8/27/24.
//

import UIKit

class FinancialPlanCreateVC: UIViewController {
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
}

// MARK: - 날짜 기본값 = 한국 시간 오늘로 설정
extension FinancialPlanCreateVC {
    private func setupInitialDate() {
        let today = Date()
        datePicker.date = today
        textField.text = FinancialPlanDateModel.dateFormatter.string(from: today)
    }
    
    private func setupDatePickerTarget() {
        let today = Date()
        datePicker.date = today
        textField.text = FinancialPlanDateModel.dateFormatter.string(from: today)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        textField.text = FinancialPlanDateModel.dateFormatter.string(from: sender.date)
    }
}

// MARK: - 화면전환관련
extension FinancialPlanCreateVC {
    private func setupActions() {
        financialPlanCreateView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    @objc func confirmButtonTapped() {
        let financialPlanCurrentPlanVC = FinancialPlanCurrentPlanVC()
        navigationController?.pushViewController(financialPlanCurrentPlanVC, animated: true)
    }
}


