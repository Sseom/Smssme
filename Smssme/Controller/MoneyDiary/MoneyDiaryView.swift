//
//  FinancialLedgerView.swift
//  Smssme
//
//  Created by KimRin on 8/28/24.
//

import UIKit

import SnapKit

class MoneyDiaryView: UIView {
    lazy var calendarView = CalendarView()
    
    let titleLabel = LargeTitleLabel().createLabel(with: "", color: .black)
    let previousButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(systemName: "arrowshape.left.circle"), for: .normal)
        return button
    }()
    
    let nextButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(systemName: "arrowshape.right.circle"), for: .normal)
        return button
    }()

    let segmentController = {
        let segmentController = UISegmentedControl(items: ["캘린더", "소비내역 차트"])
        segmentController.selectedSegmentIndex = 0
        return segmentController
    }()
    
    
    
    let budgetPlanButton = BaseButton().createButton(text: "날짜로 이동", color: .blue, textColor: .white)
    
    let todayButton = BaseButton().createButton(text: "오늘", color: .blue, textColor: .white)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        
        [
            self.titleLabel,
            self.previousButton,
            self.nextButton,
            self.calendarView,
            self.todayButton,
            self.segmentController,
            self.budgetPlanButton
        ].forEach { self.addSubview($0) }
        
        self.titleLabel.snp.makeConstraints {
            $0.top.equalTo(self).offset(10)
            $0.height.equalTo(30)
            $0.centerX.equalTo(self)
        }
        self.previousButton.snp.makeConstraints {
            $0.trailing.equalTo(self.titleLabel.snp.leading).offset(-10)
            $0.centerY.equalTo(self.titleLabel)
            $0.width.equalTo(30)
            
        }
        self.nextButton.snp.makeConstraints {
            $0.leading.equalTo(self.titleLabel.snp.trailing).offset(10)
            $0.centerY.equalTo(self.titleLabel)
            $0.width.equalTo(30)
            
        }
        self.todayButton.snp.makeConstraints {
            $0.trailing.equalTo(previousButton.snp.leading).offset(-20)
            $0.top.equalTo(nextButton.snp.top)
            $0.height.equalTo(nextButton.snp.height)
            $0.width.equalTo(50)
        }
        self.budgetPlanButton.snp.makeConstraints {
            $0.leading.equalTo(nextButton.snp.trailing).offset(20)
            $0.top.equalTo(nextButton.snp.top)
            $0.height.equalTo(nextButton.snp.height)
            $0.width.equalTo(60)
        }
        self.segmentController.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.height.equalTo(30)
            $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
        self.calendarView.snp.makeConstraints {
            $0.top.equalTo(self.segmentController.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(self.snp.horizontalEdges)
            $0.bottom.equalTo(self.snp.bottom)
        }
    }
    
}
