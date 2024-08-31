//
//  FinancialPlanConfirmView.swift
//  Smssme
//
//  Created by 임혜정 on 8/28/24.
//

import SnapKit
import UIKit

final class FinancialPlanConfirmView: UIView {
    private let confirmLargeTitle = LargeTitleLabel().createLabel(with: "자산플랜이 완성 되었습니다!", color: UIColor.black)
    
    private let imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = UIColor(hex: "e9e9e9")
        return stackView
    }()
    
    private let dummyLabel = ContentLabel().createLabel(with: "이미지영역입니다", color: UIColor.black)
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        return stackView
    }()
    
    private let editButton = BaseButton().createButton(text: "수정", color: UIColor.lightGray, textColor: UIColor.black)
    
    lazy var confirmButton = BaseButton().createButton(text: "확인", color: UIColor.systemBlue, textColor: UIColor.white)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [confirmLargeTitle, imageStackView, dummyLabel, contentStackView, editButton, confirmButton].forEach {
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
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-120)
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
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-60)
            $0.width.equalTo(80)
            $0.height.equalTo(40)
            $0.trailing.equalToSuperview().offset(-100)
        }
        
        addConfirmLabel()
    }
    
    private func addConfirmLabel() {
        (1...4).forEach { label in
            let label = ContentLabel().createLabel(with: "자산설정더미더미값", color: UIColor.black)
            contentStackView.addArrangedSubview(label)
        }
    }
}
