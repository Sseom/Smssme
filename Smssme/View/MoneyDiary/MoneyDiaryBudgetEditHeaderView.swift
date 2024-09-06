//
//  MoneyDiaryBudgetEditCell.swift
//  Smssme
//
//  Created by 전성진 on 9/2/24.
//

import UIKit

class MoneyDiaryBudgetEditHeaderView: UIView {
    let section: Int
    let titleText: String
    // MARK: - Properties
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = titleText
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

    
    init(section: Int, titleText: String) {
        self.section = section
        self.titleText = titleText
        super.init(frame: .zero)
        
        switch section {
        case 0:
            self.backgroundColor = UIColor(hex: "#3FB6DC")
        case 1:
            self.backgroundColor = UIColor(hex: "#2DC76D")
        case 2:
            self.backgroundColor = UIColor(hex: "#FF7052")
        case 3:
            self.backgroundColor = UIColor(hex: "#FFC800")
        default:
            self.backgroundColor = .lightGray
        }
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
