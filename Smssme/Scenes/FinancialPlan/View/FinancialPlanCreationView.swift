//
//  FinancialPlanCreationView.swift
//  Smssme
//
//  Created by 임혜정 on 8/27/24.
//

import UIKit
import SnapKit

class FinancialPlanCreationView: UIView {
    let textFieldArea: CreatePlanTextFieldView
    
    lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.boldSystemFont(ofSize: 24)
        let fontSize: CGFloat = 16
        let kernValue = fontSize * -0.04
        textField.attributedText = NSAttributedString(string: "", attributes: [
            .kern: kernValue
        ])
        return textField
    }()
    
    private lazy var tooltipView: TooltipView = {
        let tooltip = TooltipView(text: "제목을 지어주세요")
        tooltip.isHidden = true
        tooltip.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideTooltip))
        tooltip.addGestureRecognizer(tapGesture)
        return tooltip
    }()
    
    lazy var confirmButton = BaseButton().createButton(text: "확인", color: UIColor.black, textColor: UIColor.white)
    
    init(textFieldArea: CreatePlanTextFieldView) {
        self.textFieldArea = textFieldArea
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [
            titleTextField,
            tooltipView,
            textFieldArea,
            confirmButton].forEach {
                addSubview($0)
            }
        
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.equalTo(20)
        }
        
        tooltipView.snp.makeConstraints {
            $0.leading.equalTo(titleTextField.snp.trailing).offset(10)
            $0.centerY.equalTo(titleTextField)
        }
        
        textFieldArea.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(20)
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
    //  툴팁 동작
    @objc func hideTooltip() {
        UIView.animate(withDuration: 0.1) {
            self.tooltipView.alpha = 0
        } completion: { _ in
            self.tooltipView.isHidden = true
            self.tooltipView.alpha = 1
        }
    }
    
    func showTooltip() {
        tooltipView.isHidden = false
        tooltipView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.tooltipView.alpha = 1
        }
    }
}

class CreatePlanTextFieldView: UIView {
    var onDatePickerValueChanged: (() -> Void)?
    
    private let amountGoalLabel = ContentLabel().createLabel(with: "목표금액", color: UIColor(hex: "#333333"))
    
    lazy var infoButton = ButtonFactory.clearButton()
        .setTitle(" 평균 금액 가이드나 관련 정보를 드릴까요? ")
        .setFont(.boldSystemFont(ofSize: 12))
        .setTitleColor(.primaryBlue)
        .setBorderColor(.clear)
        .build()
    
    private let currentSavedLabel = ContentLabel().createLabel(with: "현재저축금액", color: UIColor(hex: "#333333"))
    private let startDateLabel = ContentLabel().createLabel(with: "시작날짜", color: UIColor(hex: "#333333"))
    private let endDateLabel = ContentLabel().createLabel(with: "종료날짜", color: UIColor(hex: "#333333"))
    
    lazy var targetAmountField = AmountTextField.createTextField(keyboard: .numberPad, currencyText: "원")
    lazy var currentSavedField = AmountTextField.createTextField(keyboard: .numberPad, currencyText: "원")
    
    lazy var startDateField = GoalDateTextField.createTextField()
    lazy var endDateField = GoalDateTextField.createTextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [amountGoalLabel, 
         infoButton,
         targetAmountField, currentSavedLabel, currentSavedField, startDateLabel, startDateField, endDateLabel, endDateField].forEach {
            addSubview($0)
        }
        
        amountGoalLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.leading.equalToSuperview().offset(20)
        }
        
        infoButton.snp.makeConstraints {
            $0.centerY.equalTo(amountGoalLabel)
            $0.leading.equalTo(amountGoalLabel.snp.trailing).offset(10)
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

extension CreatePlanTextFieldView {
    private func setupGestureRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        recognizer.cancelsTouchesInView = false
        self.addGestureRecognizer(recognizer)
    }
    
    // MARK: - Objc
    @objc private func handleTap() {
        self.endEditing(true)
    }
}


// MARK: -  툴팁테스트 , 잘되면 재사용가능하게 분리할 것
class TooltipView: UIView {
    private let contentView = UIView()
    private let label = UILabel()
    
    init(text: String) {
        super.init(frame: .zero)
        setup(text: text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(text: String) {
        addSubview(contentView)
        contentView.addSubview(label)
        
        backgroundColor = .clear
        contentView.backgroundColor = .primaryBlue.withAlphaComponent(1)
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        
        label.text = text
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        
        contentView.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        
        label.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 2, bottom: 8, right: 8))
        }
    }
    
    override func draw(_ rect: CGRect) {
        let arrowWidth: CGFloat = 8
        let arrowHeight: CGFloat = 10
        
        let path = UIBezierPath(roundedRect: CGRect(x: arrowWidth, y: 0, width: rect.width - arrowWidth, height: rect.height), cornerRadius: 8)
        
        let arrowYCenter = rect.height / 2
        path.move(to: CGPoint(x: arrowWidth, y: arrowYCenter - arrowHeight/2))
        path.addLine(to: CGPoint(x: 0, y: arrowYCenter))
        path.addLine(to: CGPoint(x: arrowWidth, y: arrowYCenter + arrowHeight/2))
        
        UIColor.primaryBlue.withAlphaComponent(1).setFill()
        path.fill()
    }
}
