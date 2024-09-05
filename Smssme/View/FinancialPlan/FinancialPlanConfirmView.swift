//
//  FinancialPlanConfirmView.swift
//  Smssme
//
//  Created by 임혜정 on 8/28/24.
//

import SnapKit
import UIKit

final class FinancialPlanConfirmView: UIView {
    let confirmLargeTitle = LargeTitleLabel().createLabel(with: "", color: UIColor.black)
    
    private let imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = UIColor(hex: "#e9e9e9")
        return stackView
    }()
    
    private let dummyLabel = ContentLabel().createLabel(with: "이미지영역입니다", color: UIColor.black)
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.layer.borderColor = UIColor(hex: "#000000").cgColor
        stackView.layer.borderWidth = 1
        return stackView
    }()
    
    let amountGoalLabel = ContentLabel().createLabel(with: "목표금액", color: UIColor(hex: "#333333"))
    let currentSavedLabel = ContentLabel().createLabel(with: "현재저축금액", color: UIColor(hex: "#333333"))
    let endDateLabel = ContentLabel().createLabel(with: "목표날짜", color: UIColor(hex: "#333333"))
    let daysLeftLabel = ContentLabel().createLabel(with: "남은날짜", color: UIColor(hex: "#333333"))
    
    let editButton = BaseButton().createButton(text: "수정", color: UIColor.lightGray, textColor: UIColor.black)
    
    let deleteButton = BaseButton().createButton(text: "플랜삭제", color: UIColor.systemBlue, textColor: UIColor.white)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addLabels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [confirmLargeTitle, imageStackView, dummyLabel, contentStackView, editButton, deleteButton].forEach {
            addSubview($0)
        }
        
        confirmLargeTitle.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        imageStackView.snp.makeConstraints {
            $0.top.equalTo(confirmLargeTitle.snp.bottom).offset(40)
            $0.width.equalTo(300)
            $0.height.equalTo(250)
            $0.centerX.equalToSuperview()
        }
        
        dummyLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(imageStackView.snp.centerY)
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.equalTo(imageStackView.snp.bottom).offset(40)
            $0.width.equalTo(300)
            $0.height.equalTo(200)
            $0.centerX.equalToSuperview()
        }
        
        editButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-60)
            $0.width.equalTo(80)
            $0.height.equalTo(40)
            $0.leading.equalToSuperview().offset(100)
        }
        
        deleteButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-60)
            $0.width.equalTo(80)
            $0.height.equalTo(40)
            $0.trailing.equalToSuperview().offset(-100)
        }
    }
    
    private func addLabels() {
        [amountGoalLabel, currentSavedLabel, endDateLabel, daysLeftLabel].forEach {
            contentStackView.addSubview($0)
        }
        
        amountGoalLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
        }
        
        currentSavedLabel.snp.makeConstraints {
            $0.top.equalTo(amountGoalLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        endDateLabel.snp.makeConstraints {
            $0.top.equalTo(currentSavedLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        daysLeftLabel.snp.makeConstraints {
            $0.top.equalTo(endDateLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
    }
}
