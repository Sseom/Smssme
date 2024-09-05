//
//  FinancialLedgerView.swift
//  Smssme
//
//  Created by KimRin on 8/28/24.
//

import DGCharts
import SnapKit
import UIKit

class MoneyDiaryView: UIView {
    lazy var calendarView = CalendarView()
    lazy var chartView: PieChartView = {
        let chartView = PieChartView()
        chartView.isHidden = true
        return chartView
    }()
    
    let currentDateLabel = LargeTitleLabel().createLabel(with: "", color: .black)
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

    let moveDateButton = BaseButton().createButton(text: "날짜이동", color: .blue, textColor: .white)
    
    let todayButton = BaseButton().createButton(text: "오늘", color: .blue, textColor: .white)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureWeekLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureWeekLabel() {
        calendarView.weekStackView.distribution = .fillEqually
        let dayOfTheWeek = ["일", "월", "화", "수", "목", "금", "토"]
        for i in 0...6 {
            let label = UILabel()
            label.text = dayOfTheWeek[i]
            switch label.text {
            case "토": label.textColor = .blue
            case "일": label.textColor = .red
            default: label.textColor = .black
            }
            label.backgroundColor = .systemGray.withAlphaComponent(0.2)
            label.font = .systemFont(ofSize: 13, weight: .bold)
            label.layer.borderColor = UIColor.systemGray.cgColor
            label.layer.borderWidth = 1.0
            label.textAlignment = .center
            calendarView.weekStackView.addArrangedSubview(label)
        }
    }
    
    private func configureUI() {
        
        [
            currentDateLabel,
            previousButton,
            nextButton,
            calendarView,
            chartView,
            todayButton,
            segmentController,
            moveDateButton
        ].forEach { self.addSubview($0) }
        
        
        self.currentDateLabel.snp.makeConstraints {
            $0.top.equalTo(self).offset(10)
            $0.height.equalTo(30)
            $0.centerX.equalTo(self)
        }
        self.previousButton.snp.makeConstraints {
            $0.trailing.equalTo(self.currentDateLabel.snp.leading).offset(-10)
            $0.centerY.equalTo(self.currentDateLabel)
            $0.width.equalTo(30)
            
        }
        self.nextButton.snp.makeConstraints {
            $0.leading.equalTo(self.currentDateLabel.snp.trailing).offset(10)
            $0.centerY.equalTo(self.currentDateLabel)
            $0.width.equalTo(30)
            
        }
        self.todayButton.snp.makeConstraints {
            $0.trailing.equalTo(previousButton.snp.leading).offset(-20)
            $0.top.equalTo(nextButton.snp.top)
            $0.height.equalTo(nextButton.snp.height)
            $0.width.equalTo(50)
        }
        self.moveDateButton.snp.makeConstraints {
            $0.leading.equalTo(nextButton.snp.trailing).offset(20)
            $0.top.equalTo(nextButton.snp.top)
            $0.height.equalTo(nextButton.snp.height)
            $0.width.equalTo(80)
        }
        self.segmentController.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.top.equalTo(currentDateLabel.snp.bottom).offset(10)
            $0.height.equalTo(30)
            $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
        self.calendarView.snp.makeConstraints {
            $0.top.equalTo(self.segmentController.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(self.snp.horizontalEdges)
            $0.bottom.equalTo(self.snp.bottom)
        }
        self.chartView.snp.makeConstraints {
            $0.top.equalTo(self.segmentController.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(self.snp.horizontalEdges)
            $0.bottom.equalTo(self.snp.bottom)
        }

    }
    
}

