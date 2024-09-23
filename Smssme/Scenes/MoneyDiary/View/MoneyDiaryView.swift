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
    
    var dateButton = BaseButton().createButton(text: "날짜", color: .white, textColor: .black)
    let previousButton = {
        let button = UIButton()
        button.tintColor = .white
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 15
        return button
    }()
    
    let nextButton = {
        let button = UIButton()
        button.tintColor = .white
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 15
        return button
    }()

    let segmentController = {
        let segmentController = UISegmentedControl(items: ["캘린더", "소비내역 차트"])
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 18)
        ]
        segmentController.setTitleTextAttributes(attributes, for: .normal)
        
        segmentController.selectedSegmentIndex = 0
        segmentController.backgroundColor = .blue.withAlphaComponent(0.6)
        segmentController.selectedSegmentTintColor = .blue
        return segmentController
    }()

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
        button.layer.zPosition = 999
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
        button.layer.zPosition = 999
        
        return button
    }()

    
    var moveBudgetButton = BaseButton().createButton(text: "예산안", color: .blue.withAlphaComponent(0.9), textColor: .white)
    
    var todayButton = BaseButton().createButton(text: "오늘", color: .blue.withAlphaComponent(0.9), textColor: .white)
    
//    private let pencilButton: UIButton = {
//        let button = UIButton()
//        button.setBackgroundImage(UIImage(named: "pencilButton"), for: .normal)
//        return button
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureWeekLabel()
        dateButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        self.backgroundColor = .white
        moveBudgetButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        todayButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
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
            $0.top.equalTo(self).offset(10)
            $0.height.equalTo(30)
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
            $0.trailing.equalTo(previousButton.snp.leading).offset(-20)
            $0.centerY.equalTo(self.dateButton)
            $0.height.equalTo(nextButton.snp.height).offset(5)
            $0.width.equalTo(50)
        }

        self.moveBudgetButton.snp.makeConstraints {

            $0.leading.equalTo(nextButton.snp.trailing).offset(10)
            $0.centerY.equalTo(self.dateButton)
            $0.height.equalTo(nextButton.snp.height).offset(5)
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
        

//        pencilButton.snp.makeConstraints {
//            $0.bottom.equalToSuperview().offset(-60)
//            $0.trailing.equalToSuperview().offset(-20)
//            $0.width.height.equalTo(50)
//        }
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

