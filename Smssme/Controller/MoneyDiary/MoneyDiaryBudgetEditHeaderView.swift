//
//  MoneyDiaryBudgetEditCell.swift
//  Smssme
//
//  Created by 전성진 on 9/2/24.
//

import UIKit

class MoneyDiaryBudgetEditHeaderView: UIView {
    let section: Int
    let text: String
    // MARK: - Properties
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = text
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        
        return label
    }()
    
    init(section: Int, text: String) {
        self.section = section
        self.text = text
        super.init(frame: .zero)
        
        switch section {
        case 0:
            self.backgroundColor = .blue
        case 1:
            self.backgroundColor = .green
        case 2:
            self.backgroundColor = .red
        case 3:
            self.backgroundColor = .yellow
        default:
            self.backgroundColor = .lightGray
        }
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(label)
        
        label.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
}
