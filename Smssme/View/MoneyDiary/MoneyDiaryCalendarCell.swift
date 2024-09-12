//
//  MoneyDiaryCell.swift
//  Smssme
//
//  Created by KimRin on 8/28/24.
//

import UIKit
import SnapKit

final class CalendarCollectionViewCell: UICollectionViewCell, CellReusable {
    
    let dayLabel = SmallTitleLabel().createLabel(with: "", color: .black)
    let incomeLabel = SmallTitleLabel().createLabel(with: "", color: .blue)
    let expenseLabel = SmallTitleLabel().createLabel(with: "", color: .red)
    var currentDate: Date?
    private let totalAmountLabel = SmallTitleLabel().createLabel(with: "", color: .black)
    private lazy var moneyStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.incomeLabel, self.expenseLabel, self.totalAmountLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        stackView.alignment = .center
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellUI()
        setupAutoLayout()
        self.backgroundColor = .white
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 0.2
    }
    
    func updateDate(item: CalendarItem) {
        currentDate = item.date
        
        isThisMonth(today: item)
        
        //당일날테두리 변경
        isToday(currentDay: item.date)
        dateStringFormatter(date: item.date)
        
        
        
        
        
        dayLabel.text = dateStringFormatter(date: item.date)
        
        
        
        guard let temp = DiaryCoreDataManager.shared.fetchDiaries(on: item.date)
        else { return }
        var income = 0
        var expense = 0
        
        for i in temp {
            if i.statement  {
                income += Int(i.amount)
            }
            else {
                expense += Int(i.amount)
            }
        }
        let totalAmount = income + (-expense)
        
        self.expenseLabel.text = expense == 0 ? "" : "\(expense)"
        self.incomeLabel.text = income == 0 ? "" : "\(income)"
        self.totalAmountLabel.text = totalAmount == 0 ? "" : "\(totalAmount)"
    }
    private func dateStringFormatter(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let temp = dateFormatter.string(from: date)
        let dayString = matchPattern(today: temp)
        
        if dayString == "1" {
            let month = String(Calendar.current.component(.month, from: date))
            let monthString = matchPattern(today: month)
            return "\(month).\(dayString)"
        } else {
            return dayString
        }
    }
    
    
    //정규표현식
    private func matchPattern(today: String) -> String {
        
        let regexPattern = "\\b0+(\\d{1,})\\b"
        do {
            let regex = try NSRegularExpression(pattern: regexPattern)
            
            // NSRegularExpression에서 처리된 결과를 대체하는 함수
            let result = regex.stringByReplacingMatches(in: today, options: [], range: NSRange(today.startIndex..., in: today), withTemplate: "$1")
            return result
            
        } catch {
            return "Invalid regex pattern"
            
        }
        
    }
    private func isThisMonth(today: CalendarItem) {
        let weekday = DateManager.shared.getWeekdayNum(month: today.date)
        
        switch weekday {
        case 1: self.dayLabel.textColor = .red
        case 7: self.dayLabel.textColor = .blue
        default: self.dayLabel.textColor = .black
        }
        
        if today.isThisMonth != true {
            dayLabel.textColor = self.dayLabel.textColor.withAlphaComponent(0.4)
            }
        else {
            
        }

    }
    private func isToday(currentDay: Date) {
        let today = DateManager.shared.transformDateWithoutTime(date: Date())
        if currentDay == today {
            self.layer.borderColor = UIColor.red.cgColor
            self.layer.borderWidth = 0.5
        }
        else {
            self.layer.borderColor = UIColor.gray.cgColor
            self.layer.borderWidth = 0.2
        }
    }
    
    
    private func setupCellUI() {
        dayLabel.font = .boldSystemFont(ofSize: 12)
        [
            dayLabel,
            moneyStackView
        ].forEach { self.addSubview($0) }
        [
            incomeLabel,
            expenseLabel,
            totalAmountLabel
            
        ].forEach {
            $0.textAlignment = .center
            $0.numberOfLines = 1
            $0.font = .systemFont(ofSize: 15)
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.6
            //글자 최소사이즈는 15의 60프로까지(9)까지만 작아짐 넘을경우 셀밖으로 나감
        }
    }
    
    private func setupAutoLayout() {
        dayLabel.snp.makeConstraints {
            $0.leading.equalTo(self.snp.leading).offset(3)
            $0.top.equalTo(self.snp.top).offset(3)
        }
        moneyStackView.snp.makeConstraints {
            $0.bottom.equalTo(self.snp.bottom).inset(2)
            $0.centerX.equalTo(self.snp.centerX)
            $0.height.equalTo(30)
        }
    }
    
    
}
