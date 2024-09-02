//
//  MoneyDiaryBudgetEditCell.swift
//  Smssme
//
//  Created by 전성진 on 9/2/24.
//

import UIKit

class MoneyDiaryBudgetEditCell: UITableViewCell {
    
    // MARK: - Properties
    var budget: BudgetItem?
    
    let categoryTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let amountTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("삭제", for: .normal)
        //            button.isHidden = true // 기본적으로 숨김
        return button
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(categoryTextField)
        contentView.addSubview(amountTextField)
        contentView.addSubview(deleteButton)
        
        categoryTextField.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading).offset(16)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.trailing.equalTo(amountTextField.snp.leading).offset(-16)
            $0.width.equalTo(contentView.snp.width).multipliedBy(0.5)
        }
        
        amountTextField.snp.makeConstraints {
            $0.trailing.equalTo(deleteButton.snp.leading).offset(-8)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.width.equalTo(100)
        }
        
        deleteButton.snp.makeConstraints {
            $0.trailing.equalTo(contentView.snp.trailing).offset(-16)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.width.equalTo(50)
            $0.height.equalTo(30)
        }
    }}
