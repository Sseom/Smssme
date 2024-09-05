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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateDate(item: CalendarItem) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        
        
        
        let dayString = dateFormatter.string(from: item.date)
        
        if dayString == "01" {
            dateFormatter.dateFormat = "MM.dd"
            let dayStringWithMonth = dateFormatter.string(from: item.date)
            dayLabel.text = dayStringWithMonth
        }
        else {
            dayLabel.text = dayString
        }
        
        
        let weekday = DateManager.shared.getWeekdayNum(month: item.date)
        
        switch weekday {
        case 1: self.dayLabel.textColor = .red
        case 7: self.dayLabel.textColor = .blue
        default: self.dayLabel.textColor = .black
        }
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
        
        self.expenseLabel.text = "\(expense)"
        self.incomeLabel.text = "\(income)"
        self.totalAmountLabel.text = "\(totalAmount)"
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
