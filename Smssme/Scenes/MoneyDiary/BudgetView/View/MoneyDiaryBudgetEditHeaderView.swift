//
//  MoneyDiaryBudgetEditCell.swift
//  Smssme
//
//  Created by 전성진 on 9/2/24.
//

import UIKit

class MoneyDiaryBudgetEditHeaderView: UITableViewHeaderFooterView {
    // MARK: - Properties
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .white
        
        return label
    }()
    
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.text = "0 원"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .white
        
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
        setupBackground()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBackground() {
        let backgroundView = UIView(frame: self.bounds)
        backgroundView.backgroundColor = UIColor(hex: "#FFC800")  // 원하는 배경색으로 설정
        self.backgroundView = backgroundView
    }
    
    private func setupViews() {
        [titleLabel, amountLabel].forEach {
            self.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
        }
        amountLabel.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.centerY.equalToSuperview()
        }
    }
}
