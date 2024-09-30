//
//  FinancialPlanConfirmView.swift
//  Smssme
//
//  Created by 임혜정 on 8/28/24.
//

import SnapKit
import UIKit

final class FinancialPlanConfirmView: UIView {
    let confirmLargeTitle = LabelFactory.titleLabel()
        .build()
    let incompleteButtonView = ButtonIncomplete()
    let completeButtonView = ButtonComplete()
    
    let confirmImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .clear
        image.image = UIImage(named: "myPlanConfirm")
        return image
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 20
        return stackView
    }()
    
    private let buttonArea: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        return stackView
    }()
    
    let amountGoalTitleLabel = LabelFactory.bodyLabel()
        .setText("목표금액")
        .build()
    
    let amountGoalLabel = LabelFactory.bodyLabel()
        .build()
    
    let currentSavedTitleLabel = LabelFactory.bodyLabel()
        .setText("지금까지 모은 금액")
        .build()
    
    let currentSavedLabel = LabelFactory.bodyLabel()
        .build()
    
    let endDateTitleLabel = LabelFactory.bodyLabel()
        .setText("목표날짜")
        .build()
    
    let endDateLabel = LabelFactory.bodyLabel()
        .build()
    
    let daysLeftTitleLabel = LabelFactory.bodyLabel()
        .setText("남은날짜")
        .build()
    
    let daysLeftLabel = LabelFactory.bodyLabel()
        .build()
    
    let monthlyGoalsTitleLabel = LabelFactory.bodyLabel()
        .setText("이번달 저축할 금액")
        .build()
    
    let monthlyGoalsLabel = LabelFactory.bodyLabel()
        .build()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [
            confirmLargeTitle,
            confirmImage,
            contentStackView,
            buttonArea,
        ].forEach { addSubview($0) }
        
        confirmLargeTitle.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        confirmImage.snp.makeConstraints {
            $0.top.equalTo(confirmLargeTitle.snp.bottom).offset(50)
            $0.width.equalTo(300)
            $0.height.equalTo(240)
            $0.centerX.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.equalTo(confirmImage.snp.bottom).offset(-20)
            $0.width.equalTo(300)
            $0.height.equalTo(200)
            $0.centerX.equalToSuperview()
        }
        
        buttonArea.snp.makeConstraints {
            $0.top.equalTo(contentStackView.snp.bottom).offset(20)
            $0.height.equalTo(40)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        setupSubTitle()
        setupDataLabel()
        
        // 플랜의 완료 가능상태에 따라서 버튼 뷰를 달리함
        [incompleteButtonView, 
         completeButtonView
        ].forEach { buttonArea.addArrangedSubview($0)
            // 버튼 뷰 높이 buttonArea에 맞추게
            $0.snp.makeConstraints {
                $0.height.equalTo(40)
            }
        }
        
        incompleteButtonView.isHidden = false
        completeButtonView.isHidden = true
    }
    
    func updateButtonAreaState(achievable: Bool) {
        incompleteButtonView.isHidden = achievable
        completeButtonView.isHidden = !achievable
    }
    
    private func setupDataLabel() {
        [
            amountGoalLabel,
            currentSavedLabel,
            endDateLabel,
            monthlyGoalsLabel,
            daysLeftLabel,
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
        
        monthlyGoalsLabel.snp.makeConstraints {
            $0.top.equalTo(currentSavedLabel.snp.bottom).offset(16)
            $0.trailing.equalToSuperview()
        }
        
        endDateLabel.snp.makeConstraints {
            $0.top.equalTo(monthlyGoalsLabel.snp.bottom).offset(16)
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
            monthlyGoalsTitleLabel,
            daysLeftTitleLabel,
            
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
        
        monthlyGoalsTitleLabel.snp.makeConstraints {
            $0.top.equalTo(currentSavedTitleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview()
        }
        
        endDateTitleLabel.snp.makeConstraints {
            $0.top.equalTo(monthlyGoalsTitleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview()
        }
        
        daysLeftTitleLabel.snp.makeConstraints {
            $0.top.equalTo(endDateTitleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview()
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

class ButtonIncomplete: UIView {
    let editButton = ActionButtonBorder().createButton(text: "수정", color: UIColor.black, textColor: UIColor.black)
    let deleteButton = ActionButtonBlack2().createButton(text: "플랜삭제", color: UIColor.black, textColor: UIColor.white)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        [
            editButton,
            deleteButton
        ].forEach {
            addSubview($0)
        }
        
        editButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.width.equalTo(80)
            $0.height.equalTo(40)
            $0.leading.equalToSuperview().offset(80)
            $0.centerY.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.width.equalTo(80)
            $0.height.equalTo(40)
            $0.trailing.equalToSuperview().offset(-80)
            $0.centerY.equalToSuperview()
        }
    }
}

class ButtonComplete: UIView {
    let completeButton = ActionButtonBlack2().createButton(text: "완료하기", color: UIColor(hex: "#3756F4"), textColor: UIColor.white)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        [ //뭔가 추가될지도..
            completeButton,
        ].forEach {
            addSubview($0)
        }
        
        completeButton.snp.makeConstraints {
            $0.width.equalTo(80)
            $0.height.equalTo(40)
            $0.centerY.centerX.equalToSuperview()
        }
    }
}
