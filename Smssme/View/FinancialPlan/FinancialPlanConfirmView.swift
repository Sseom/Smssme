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
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 20
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
        setBackgroundImage(named: "dummy")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [confirmLargeTitle,  contentStackView, ].forEach {
            addSubview($0)
        }
        
        confirmLargeTitle.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints {

            $0.width.equalTo(340)
            $0.height.equalTo(200)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }
    
    private func addLabels() {
        [amountGoalLabel, currentSavedLabel, endDateLabel, daysLeftLabel, editButton, deleteButton].forEach {
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
        
        editButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-10)
            $0.width.equalTo(80)
            $0.height.equalTo(40)
            $0.leading.equalToSuperview().offset(60)
        }
        
        deleteButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-10)
            $0.width.equalTo(80)
            $0.height.equalTo(40)
            $0.trailing.equalToSuperview().offset(-60)
        }
    }
}

extension FinancialPlanConfirmView {
    func setBackgroundImage(named imageName: String) {
        let setImage: () -> Void = { [weak self] in
            guard let self = self else { return }
            
            if let backgroundImage = UIImage(named: imageName) {
                let imageView = UIImageView(image: backgroundImage)
                imageView.contentMode = .scaleAspectFill
                imageView.frame = self.bounds
                imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                
                self.insertSubview(imageView, at: 0)
            }
        }
        
        if Thread.isMainThread {
            setImage()
        } else {
            DispatchQueue.main.async(execute: setImage)
        }
    }
}
