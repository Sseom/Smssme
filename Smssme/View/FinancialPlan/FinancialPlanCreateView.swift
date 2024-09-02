//
//  FinancialPlanCreateView.swift
//  Smssme
//
//  Created by 임혜정 on 8/27/24.
//

import UIKit
import SnapKit

class FinancialPlanCreateView: UIView {
    private let textFieldArea: CreateTextView
    private let planCreateTitle = LargeTitleLabel().createLabel(with: "세부자금플랜", color: UIColor.black)
    lazy var confirmButton = BaseButton().createButton(text: "확인", color: UIColor.black, textColor: UIColor.white)
    
    init(textFieldArea: CreateTextView) {
        self.textFieldArea = textFieldArea
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [planCreateTitle, textFieldArea, confirmButton].forEach {
            addSubview($0)
        }
        
        planCreateTitle.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.equalTo(20)
        }
        
        textFieldArea.snp.makeConstraints {
            $0.top.equalTo(planCreateTitle.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(450)
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(textFieldArea.snp.bottom).offset(60)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(80)
            $0.height.equalTo(40)
        }
    }
}

class CreateTextView: UIView {
    var onDatePickerValueChanged: (() -> Void)?
    
    private let amountGoalLabel = ContentLabel().createLabel(with: "목표금액", color: UIColor(hex: "#333333"))
    private let currentSavedLabel = ContentLabel().createLabel(with: "현재저축금액", color: UIColor(hex: "#333333"))
    private let startDateLabel = ContentLabel().createLabel(with: "시작날짜", color: UIColor(hex: "#333333"))
    private let endDateLabel = ContentLabel().createLabel(with: "종료날짜", color: UIColor(hex: "#333333"))
    
    lazy var targetAmountField = AmountTextField.createTextField(keyboard: .numberPad, defaultValue: 0)
    lazy var currentSavedField = AmountTextField.createTextField(keyboard: .numberPad, defaultValue: 0)
    
    let startDateField = GoalDateTextField.createTextField(keyboard: .numberPad)
    let endDateField = GoalDateTextField.createTextField(keyboard: .numberPad)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [amountGoalLabel, targetAmountField, currentSavedLabel, currentSavedField, startDateLabel, startDateField, endDateLabel, endDateField].forEach {
            addSubview($0)
        }
        
        amountGoalLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.leading.equalToSuperview().offset(20)
        }
        
        targetAmountField.snp.makeConstraints {
            $0.top.equalTo(amountGoalLabel.snp.bottom).offset(10)
            $0.height.equalTo(40)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        currentSavedLabel.snp.makeConstraints {
            $0.top.equalTo(targetAmountField.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(20)
        }
        
        currentSavedField.snp.makeConstraints {
            $0.top.equalTo(currentSavedLabel.snp.bottom).offset(10)
            $0.height.equalTo(40)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        startDateLabel.snp.makeConstraints {
            $0.top.equalTo(currentSavedField.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(20)
        }
        
        startDateField.snp.makeConstraints {
            $0.top.equalTo(startDateLabel.snp.bottom).offset(10)
            $0.height.equalTo(40)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        endDateLabel.snp.makeConstraints {
            $0.top.equalTo(startDateField.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(20)
        }
        
        endDateField.snp.makeConstraints {
            $0.top.equalTo(endDateLabel.snp.bottom).offset(10)
            $0.height.equalTo(40)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
}

// 재활용 고민중..

//class EditTextView {
//    private let amountGoalLabel = ContentLabel().createLabel(with: "목표금액", color: UIColor.systemGray5)
//    private let currentSavedLabel = ContentLabel().createLabel(with: "현재저축금액", color: UIColor.systemGray5)
//    private let startDateLabel = ContentLabel().createLabel(with: "시작날짜", color: UIColor.systemGray5)
//    private let endDateLabel = ContentLabel().createLabel(with: "종료날짜", color: UIColor.systemGray5)
//}
