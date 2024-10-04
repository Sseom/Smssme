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
        chartView.highlightPerTapEnabled = false
        return chartView
    }()
    
    var dateButton = ButtonFactory.clearButton()
        .setFont(.boldSystemFont(ofSize: 22))
        .setBorderColor(.clear)
        .build()
//
    let previousButton = ButtonFactory.circleButton(30)
        .setSymbol("chevron.left", color: .labelBlack)
        .build()
    
    let nextButton = ButtonFactory.circleButton(30)
        .setSymbol("chevron.right", color: .labelBlack)
        .build()
    
    let segmentController = {
        let segmentController = UISegmentedControl(items: ["캘린더", "소비내역 차트"])
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 16)
        ]
        segmentController.setTitleTextAttributes(attributes, for: .normal)
        segmentController.selectedSegmentIndex = 0
        segmentController.backgroundColor = .primaryBlue.withAlphaComponent(0.6)
        segmentController.selectedSegmentTintColor = .primaryBlue
        segmentController.layer.borderColor = UIColor(.clear).cgColor
        segmentController.layer.cornerRadius = 0
        return segmentController
    }()
    
    var moveBudgetButton = ButtonFactory.fillButton()
        .setTitle("예산안")
        .setFillColor(.primaryBlue)

        .build()
    
    var todayButton = ButtonFactory.fillButton()
        .setTitle("오늘")
        .setFillColor(.primaryBlue)
        .build()
    
    lazy var floatingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "pencilButton"), for: .normal)
        return button
    }()
    
    let pencilButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.image = UIImage(systemName: "pencil")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
        button.configuration = config
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        button.alpha = 0.0
        return button
    }()
    
    let quickMessageButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.image = UIImage(systemName: "text.append")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
        button.configuration = config
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        button.alpha = 0.0
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureWeekLabel()
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureWeekLabel() {
        calendarView.weekStackView.distribution = .fillEqually
        let dayOfTheWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        
        for i in 0...6 {
            let label = UILabel()
            label.text = dayOfTheWeek[i]
            switch label.text {
            case "Sat": label.backgroundColor = .systemBlue
            case "Sun": label.backgroundColor = .systemRed
            default: label.backgroundColor = .black.withAlphaComponent(0.8)
            }
            
            label.layer.borderColor = UIColor.white.cgColor
            label.layer.borderWidth = 0.5
            label.textColor = .white
            label.font = .systemFont(ofSize: 13, weight: .bold)
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
            floatingButton,
            pencilButton,
            quickMessageButton,
            moveBudgetButton
            
        ].forEach { self.addSubview($0) }
        
        
        self.dateButton.snp.makeConstraints {
            $0.top.equalTo(self).offset(20)
            $0.height.equalTo(50)
            $0.centerX.equalTo(self)
        }
        self.previousButton.snp.makeConstraints {
            $0.trailing.equalTo(self.dateButton.snp.leading).offset(-10)
            $0.centerY.equalTo(self.dateButton)
            $0.width.height.equalTo(30)
            
        }
        self.nextButton.snp.makeConstraints {
            $0.leading.equalTo(self.dateButton.snp.trailing).offset(10)
            $0.centerY.equalTo(self.dateButton)
            $0.width.height.equalTo(30)
            
        }
        self.todayButton.snp.makeConstraints {
            $0.leading.equalTo(self.safeAreaLayoutGuide).offset(20)
            $0.centerY.equalTo(self.dateButton)
            $0.height.equalTo(40)
            $0.width.equalTo(50)
        }
        
        self.moveBudgetButton.snp.makeConstraints {
            $0.trailing.equalTo(self.safeAreaLayoutGuide).inset(20)
            $0.centerY.equalTo(self.dateButton)
            $0.height.equalTo(40)
            $0.width.equalTo(60)
        }
        self.segmentController.snp.makeConstraints {
            $0.top.equalTo(dateButton.snp.bottom).offset(25)
            $0.height.equalTo(30)
            $0.leading.trailing.equalToSuperview()
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
        
        floatingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(40)
            $0.width.height.equalTo(60)
        }
        
        pencilButton.snp.makeConstraints {
            $0.centerX.equalTo(floatingButton.snp.centerX)
            $0.bottom.equalTo(floatingButton.snp.top).offset(-15)
            $0.width.height.equalTo(40)
        }
        
        quickMessageButton.snp.makeConstraints {
            $0.centerX.equalTo(floatingButton.snp.centerX)
            $0.bottom.equalTo(pencilButton.snp.top).offset(-15)
            $0.width.height.equalTo(40)
        }
        
    }
    
    
    func popButtons(isActive: Bool) {
        if isActive {
            pencilButton.layer.transform = CATransform3DMakeScale(0.4, 0.4, 1)
            UIView.animate(withDuration: 0.3, delay: 0.2, usingSpringWithDamping: 0.55, initialSpringVelocity: 0.3, options: [.curveEaseInOut], animations: { [weak self] in
                guard let self = self else { return }
                pencilButton.layer.transform = CATransform3DIdentity
                pencilButton.alpha = 1.0
                
            })
            quickMessageButton.layer.transform = CATransform3DMakeScale(0.4, 0.4, 1)
            UIView.animate(withDuration: 0.3, delay: 0.2, usingSpringWithDamping: 0.55, initialSpringVelocity: 0.3, options: [.curveEaseInOut], animations: { [weak self] in
                guard let self = self else { return }
                quickMessageButton.layer.transform = CATransform3DIdentity
                quickMessageButton.alpha = 1.0
                
            })
        } else {
            UIView.animate(withDuration: 0.15, delay: 0.2, options: []) { [weak self] in
                guard let self = self else { return }
                pencilButton.layer.transform = CATransform3DMakeScale(0.4, 0.4, 0.1)
                pencilButton.alpha = 0.0
                
                quickMessageButton.layer.transform = CATransform3DMakeScale(0.4, 0.4, 0.1)
                quickMessageButton.alpha = 0.0
                
                
            }
        }
    }
    
    
    
}

