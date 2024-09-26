//
//  CompleteModalView.swift
//  Smssme
//
//  Created by 임혜정 on 9/26/24.
//

import SnapKit
import UIKit

final class CompleteModalView: UIView {
    let confirmLargeTitle = LabelFactory.titleLabel()
        .build()
    
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
    
    let amountGoalTitleLabel = LabelFactory.bodyLabel()
        .setText("목표 금액")
        .build()
    let amountGoalLabel = LabelFactory.bodyLabel()
        .setFont(.boldSystemFont(ofSize: 16))
        .build()
    
    let currentSavedTitleLabel = LabelFactory.bodyLabel()
        .setText("모은 금액")
        .build()
    let currentSavedLabel = LabelFactory.bodyLabel()
        .setFont(.boldSystemFont(ofSize: 16))
        .build()
    
    let startTitleLabel = LabelFactory.bodyLabel()
        .setText("시작 날짜")
        .build()
    let startLabel = LabelFactory.bodyLabel()
        .setFont(.boldSystemFont(ofSize: 16))
        .build()
    
    let completeTitleLabel = LabelFactory.bodyLabel()
        .setText("완료 날짜")
        .build()
    let completeLabel = LabelFactory.bodyLabel()
        .setFont(.boldSystemFont(ofSize: 16))
        .build()
    
    let confirmButton = ButtonFactory.fillButton()
        .setTitle("확인")
        .setFillColor(.black)
        .setTitleColor(.white)
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
            confirmButton
        ].forEach {
            addSubview($0)
        }
        
        confirmLargeTitle.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(60)
            $0.centerX.equalToSuperview()
        }
        
        confirmImage.snp.makeConstraints {
            $0.top.equalTo(confirmLargeTitle.snp.bottom).offset(30)
            $0.width.equalTo(100)
            $0.height.equalTo(100)
            $0.centerX.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.equalTo(confirmImage.snp.bottom).offset(-20)
            $0.width.equalTo(300)
            $0.height.equalTo(200)
            $0.centerX.equalToSuperview()
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(contentStackView.snp.bottom).offset(30)
            $0.width.equalTo(80)
            $0.height.equalTo(40)
            $0.centerX.equalToSuperview()
        }
        
        setupSubTitle()
        setupDataLabel()
    }
    
    private func setupDataLabel() {
        [
            amountGoalLabel,
            currentSavedLabel,
            startLabel,
            completeLabel
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
        
        startLabel.snp.makeConstraints {
            $0.top.equalTo(currentSavedLabel.snp.bottom).offset(16)
            $0.trailing.equalToSuperview()
        }
        
        completeLabel.snp.makeConstraints {
            $0.top.equalTo(startLabel.snp.bottom).offset(16)
            $0.trailing.equalToSuperview()
        }
    }
    
    private func setupSubTitle() {
        [
            amountGoalTitleLabel,
            currentSavedTitleLabel,
            startTitleLabel,
            completeTitleLabel
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
        
        startTitleLabel.snp.makeConstraints {
            $0.top.equalTo(currentSavedTitleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview()
        }
        
        completeTitleLabel.snp.makeConstraints {
            $0.top.equalTo(startTitleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview()
        }
    }
}

extension CompleteModalView {
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
