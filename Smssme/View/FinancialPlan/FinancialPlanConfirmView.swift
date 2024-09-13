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
    
    let confirmImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .clear
        image.image = UIImage(named: "myPlanConfirm")
//        image.layer.borderColor = UIColor.black.cgColor
//        image.layer.borderWidth = 1
        return image
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.backgroundColor = .white
//        stackView.layer.borderColor = UIColor.black.cgColor
//        stackView.layer.borderWidth = 1
        stackView.layer.cornerRadius = 20
        return stackView
    }()
    
    private let buttonsView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
//        stackView.layer.borderColor = UIColor.black.cgColor
//        stackView.layer.borderWidth = 1
        return stackView
    }()
    
    let amountGoalTitleLabel = ContentLabel().createLabel(with: "목표금액", color: UIColor(hex: "#060b11"))
    let amountGoalLabel = ContentBoldLabel().createLabel(with: "", color: UIColor(hex: "#333333"))
    let currentSavedTitleLabel = ContentLabel().createLabel(with: "현재저축금액", color: UIColor(hex: "#060b11"))
    let currentSavedLabel = ContentBoldLabel().createLabel(with: "", color: UIColor(hex: "#333333"))
    let endDateTitleLabel = ContentLabel().createLabel(with: "목표날짜", color: UIColor(hex: "#060b11"))
    let endDateLabel = ContentBoldLabel().createLabel(with: "", color: UIColor(hex: "#333333"))
    let daysLeftTitleLabel = ContentLabel().createLabel(with: "남은날짜", color: UIColor(hex: "#060b11"))
    let daysLeftLabel = ContentBoldLabel().createLabel(with: "", color: UIColor(hex: "#333333"))
    
    let editButton = ActionButtonBorder().createButton(text: "수정", color: UIColor.black, textColor: UIColor.black)
    let deleteButton = ActionButtonBlack2().createButton(text: "플랜삭제", color: UIColor.black, textColor: UIColor.white)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [confirmLargeTitle, confirmImage, contentStackView, buttonsView].forEach {
            addSubview($0)
        }
        
        confirmLargeTitle.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        confirmImage.snp.makeConstraints {
            $0.top.equalTo(confirmLargeTitle.snp.bottom).offset(50)
            $0.width.equalTo(300)
            $0.height.equalTo(260)
            $0.centerX.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.equalTo(confirmImage.snp.bottom)
            $0.width.equalTo(300)
            $0.height.equalTo(200)
            $0.centerX.equalToSuperview()
        }
        
        buttonsView.snp.makeConstraints {
            $0.top.equalTo(contentStackView.snp.bottom).offset(10)
            $0.width.equalTo(300)
            $0.height.equalTo(40)
            $0.centerX.equalToSuperview()
        }
        
        setupSubTitle()
        setupDataLabel()
        setupButtons()
    }
    
    private func setupDataLabel() {
        [
            amountGoalLabel,
            currentSavedLabel,
            endDateLabel,
            daysLeftLabel
        ].forEach {
            contentStackView.addSubview($0)
        }
        
        amountGoalLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview()
        }
        
        currentSavedLabel.snp.makeConstraints {
            $0.top.equalTo(amountGoalLabel.snp.bottom).offset(16)
            $0.trailing.equalToSuperview()
        }
        
        endDateLabel.snp.makeConstraints {
            $0.top.equalTo(currentSavedLabel.snp.bottom).offset(16)
            $0.trailing.equalToSuperview()
        }
        
        daysLeftLabel.snp.makeConstraints {
            $0.top.equalTo(endDateLabel.snp.bottom).offset(16)
            $0.trailing.equalToSuperview()
        }
        
        
    }
    
    private func setupSubTitle() {
        [
            amountGoalTitleLabel,
            currentSavedTitleLabel,
            endDateTitleLabel,
            daysLeftTitleLabel
        ].forEach {
            contentStackView.addSubview($0)
        }
        
        amountGoalTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview()
        }
        
        currentSavedTitleLabel.snp.makeConstraints {
            $0.top.equalTo(amountGoalTitleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview()
        }
        
        endDateTitleLabel.snp.makeConstraints {
            $0.top.equalTo(currentSavedTitleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview()
        }
        
        daysLeftTitleLabel.snp.makeConstraints {
            $0.top.equalTo(endDateTitleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview()
        }
        
    }
    
    private func setupButtons() {
        [
            editButton, 
            deleteButton
        ].forEach {
            buttonsView.addSubview($0)
        }
        
        editButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-0)
            $0.width.equalTo(80)
            $0.height.equalTo(40)
            $0.leading.equalToSuperview().offset(60)
        }
        
        deleteButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-0)
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
