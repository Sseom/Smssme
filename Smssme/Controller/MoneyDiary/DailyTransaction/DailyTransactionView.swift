//
//  DailyTransactionView.swift
//  Smssme
//
//  Created by KimRin on 8/29/24.
//

import UIKit
import SnapKit
//expense, income
class DailyTransactionView: UIView {

    lazy var dateLabel: UILabel = LargeTitleLabel().createLabel(with: "1일", color: .black)

    let dailyIncome: UILabel = SmallTitleLabel().createLabel(with: "수입: 600,000", color: .blue)

    let dailyExpense: UILabel = SmallTitleLabel().createLabel(with: "지출: 200,000", color: .red)

    lazy var listCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.configureUI()
        self.setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        [self.dateLabel, self.dailyIncome, self.dailyExpense, self.listCollectionView].forEach { self.addSubview($0) }
    }
    
    
    private func setupLayout() {
        self.dateLabel.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(20)
            $0.leading.equalTo(self.snp.leading).offset(30)
            $0.height.equalTo(50)
        }

        self.dailyIncome.snp.makeConstraints {
            $0.centerY.equalTo(dateLabel.snp.centerY)
            $0.trailing.equalTo(self.dailyExpense.snp.leading).offset(-20)
        }

        self.dailyExpense.snp.makeConstraints {
            $0.centerY.equalTo(dateLabel.snp.centerY)
            $0.trailing.equalTo(self.snp.trailing).offset(-20)
        }

        self.listCollectionView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(self).inset(20)
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
