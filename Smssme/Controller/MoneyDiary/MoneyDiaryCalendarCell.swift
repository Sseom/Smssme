//
//  MoneyDiaryCell.swift
//  Smssme
//
//  Created by KimRin on 8/28/24.
//

import UIKit
import SnapKit

final class CalendarCollectionViewCell: UICollectionViewCell, CellReusable {

    
    let dayLabel = SmallTitleLabel().createLabel(with: "1", color: .black)
    let incomeLabel = SmallTitleLabel().createLabel(with: "10", color: .blue)
    let expenseLabel = SmallTitleLabel().createLabel(with: "10", color: .red)
   private let totalAmountLabel = SmallTitleLabel().createLabel(with: "10000", color: .black)
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
        self.setupCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateDate(item: CalendarItem) {
        self.dayLabel.text = item.date
        if item.isSat {
            self.dayLabel.textColor = .blue
        } else if item.isHol {
            self.dayLabel.textColor = .red
        } else {
            self.dayLabel.textColor = .black
        }
    }
    
    private func setupCellUI() {
        self.dayLabel.font = .boldSystemFont(ofSize: 12)
        [
            self.dayLabel,
            self.moneyStackView
        ].forEach { self.addSubview($0) }
        [
            self.incomeLabel,
            self.expenseLabel,
            self.totalAmountLabel
            
        ].forEach {
            //글자 오토사이징
            $0.textAlignment = .center
            $0.numberOfLines = 1
            $0.font = .systemFont(ofSize: 15)
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.6
            //글자 최소사이즈는 15의 60프로까지(9)까지만 작아짐 넘을경우 셀밖으로 나감
        }
        
        self.dayLabel.snp.makeConstraints {
            $0.leading.equalTo(self.snp.leading).offset(3)
            $0.top.equalTo(self.snp.top).offset(3)
        }
        
        self.moneyStackView.snp.makeConstraints {
            $0.bottom.equalTo(self.snp.bottom).inset(2)
            $0.centerX.equalTo(self.snp.centerX)
            $0.height.equalTo(30)
        }
    }
    

}
