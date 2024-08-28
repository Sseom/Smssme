//
//  FinancialPlanCreateView.swift
//  Smssme
//
//  Created by 임혜정 on 8/27/24.
//

import UIKit
import SnapKit

class FinancialPlanCreateView: UIView {
    private let planCreateTitle = LargeTitleLabel().createLabel(with: "세부자금플랜", color: UIColor.black)
    
    private let amountGoalLabel = ContentLabel().createLabel(with: "목표금액", color: UIColor.systemGray5)
    private let currentSavedLabel = ContentLabel().createLabel(with: "현재저축금액", color: UIColor.systemGray5)
    private let startDateLabel = ContentLabel().createLabel(with: "시작날짜", color: UIColor.systemGray5)
    private let endDateLabel = ContentLabel().createLabel(with: "종료날짜", color: UIColor.systemGray5)
    
    lazy var targetAmountField = AmountTextField.createTextField(placeholder: "", keyboard: .numberPad)
    lazy var currentSavedField = AmountTextField.createTextField(placeholder: "", keyboard: .numberPad)
    
    let startDateField = AmountTextField.createTextField(placeholder: "", keyboard: .numberPad)
    let endDateField = AmountTextField.createTextField(placeholder: "", keyboard: .numberPad)
    
    let datePicker = createDatePicker()
    let datePicker2 = createDatePicker()
    
    private let confirmButton = BaseButton().createButton(text: "확인", color: UIColor.systemBlue, textColor: UIColor.white)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [planCreateTitle, targetAmountField, amountGoalLabel, currentSavedField, currentSavedLabel, startDateField, startDateLabel, endDateLabel, endDateField, confirmButton].forEach {
            addSubview($0)
        }
        
        planCreateTitle.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.equalTo(20)
        }
        
        amountGoalLabel.snp.makeConstraints {
            $0.top.equalTo(planCreateTitle.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(40)
        }
        
        targetAmountField.snp.makeConstraints {
            $0.top.equalTo(amountGoalLabel.snp.bottom).offset(10)
            $0.height.equalTo(40)
            $0.leading.equalToSuperview().offset(40)
            $0.trailing.equalToSuperview().offset(-40)
        }
        
        currentSavedLabel.snp.makeConstraints {
            $0.top.equalTo(targetAmountField.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(40)
        }
        
        currentSavedField.snp.makeConstraints {
            $0.top.equalTo(currentSavedLabel.snp.bottom).offset(10)
            $0.height.equalTo(40)
            $0.leading.equalToSuperview().offset(40)
            $0.trailing.equalToSuperview().offset(-40)
        }
        
        startDateLabel.snp.makeConstraints {
            $0.top.equalTo(currentSavedField.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(40)
        }
        
        startDateField.snp.makeConstraints {
            $0.top.equalTo(startDateLabel.snp.bottom).offset(10)
            $0.height.equalTo(40)
            $0.leading.equalToSuperview().offset(40)
            $0.trailing.equalToSuperview().offset(-40)
        }
        
        endDateLabel.snp.makeConstraints {
            $0.top.equalTo(startDateField.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(40)
        }
        
        endDateField.snp.makeConstraints {
            $0.top.equalTo(endDateLabel.snp.bottom).offset(10)
            $0.height.equalTo(40)
            $0.leading.equalToSuperview().offset(40)
            $0.trailing.equalToSuperview().offset(-40)
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(endDateField.snp.bottom).offset(60)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(80)
            $0.height.equalTo(40)
        }
    }
}
