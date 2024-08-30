//
//  FinancialPlanCurrentPlanView.swift
//  Smssme
//
//  Created by 임혜정 on 8/29/24.
//

import SnapKit
import UIKit

final class FinancialPlanCurrentPlanView: UIView {
    private let currentPlanTitle = LargeTitleLabel().createLabel(with: "진행중인 자산플랜", color: .black)
    
    private let goalGraphArea: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = UIColor(hex: "#e9e9e9")
        return stackView
    }()
    
    private lazy var addPlanButton = ActionButton().createButton(text: "플랜 추가", color: UIColor.blue, textColor: UIColor.white, method: FinancialPlanCreateVC().confirmButtomTapped)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [currentPlanTitle, goalGraphArea, addPlanButton].forEach {
            addSubview($0)
        }
        
        currentPlanTitle.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.equalToSuperview().offset(20)
        }
        
        goalGraphArea.snp.makeConstraints {
            $0.top.equalTo(currentPlanTitle.snp.bottom).offset(20)
            $0.width.height.equalTo(300)
            $0.centerX.equalToSuperview()
        }
        
        addPlanButton.snp.makeConstraints {
            $0.top.equalTo(goalGraphArea.snp.bottom).offset(40)
            $0.width.equalTo(80)
            $0.height.equalTo(40)
            $0.centerX.equalToSuperview()
        }
    }
}
