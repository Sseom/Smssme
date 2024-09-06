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
        chartView.noDataText = "작성된 내역이 없습니다."
        chartView.isHidden = true
        return chartView
    }()
    
    var dateButton = BaseButton().createButton(text: "날짜", color: .white, textColor: .black)
    let previousButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(systemName: "arrowshape.left"), for: .normal)
        return button
    }()
    
    let nextButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(systemName: "arrowshape.right"), for: .normal)
        return button
    }()

    let segmentController = {
        let segmentController = UISegmentedControl(items: ["캘린더", "소비내역 차트"])
        segmentController.selectedSegmentIndex = 0
        return segmentController
    }()


    
    let moveBudgetButton = BaseButton().createButton(text: "예산안", color: .systemGray.withAlphaComponent(0.5), textColor: .black)
    
    let todayButton = BaseButton().createButton(text: "오늘", color: .systemGray.withAlphaComponent(0.5), textColor: .black)
    
    private let pencilButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "pencilButton"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureWeekLabel()
        dateButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        
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
    
    func addActionToPencilButton(_ action: UIAction) {
        pencilButton.addAction(action, for: .touchUpInside)
    }
    
    private func configureUI() {
        
        [
            dateButton,
            previousButton,
            nextButton,
            calendarView,
            chartView,
            todayButton,
            segmentController,
            pencilButton,
            

            moveBudgetButton,
            pencilButton

        ].forEach { self.addSubview($0) }
        
        
        self.dateButton.snp.makeConstraints {
            $0.top.equalTo(self).offset(10)
            $0.height.equalTo(30)
            $0.centerX.equalTo(self)
        }
        self.previousButton.snp.makeConstraints {
            $0.trailing.equalTo(self.dateButton.snp.leading).offset(-10)
            $0.centerY.equalTo(self.dateButton)
            $0.width.equalTo(30)
            
        }
        self.nextButton.snp.makeConstraints {
            $0.leading.equalTo(self.dateButton.snp.trailing).offset(10)
            $0.centerY.equalTo(self.dateButton)
            $0.width.equalTo(30)
            
        }
        self.todayButton.snp.makeConstraints {
            $0.trailing.equalTo(previousButton.snp.leading).offset(-20)
            $0.top.equalTo(nextButton.snp.top)
            $0.height.equalTo(nextButton.snp.height)
            $0.width.equalTo(50)
        }

        self.moveBudgetButton.snp.makeConstraints {

            $0.leading.equalTo(nextButton.snp.trailing).offset(10)
            $0.top.equalTo(nextButton.snp.top)
            $0.height.equalTo(nextButton.snp.height)
            $0.width.equalTo(65)
        }
        self.segmentController.snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.top.equalTo(dateButton.snp.bottom).offset(10)
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

        pencilButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-60)
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.height.equalTo(50)
        }
    }
    
}

