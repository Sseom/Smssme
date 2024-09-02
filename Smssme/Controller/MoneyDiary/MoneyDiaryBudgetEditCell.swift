//
//  MoneyDiaryBudgetEditCell.swift
//  Smssme
//
//  Created by 전성진 on 9/2/24.
//

import UIKit

class MoneyDiaryBudgetEditCell: UITableViewCell {

    let categoryTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "항목명"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    let amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "금액"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupUI() {
        contentView.addSubview(categoryTextField)
        contentView.addSubview(amountTextField)

        categoryTextField.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading).offset(16)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.trailing.equalTo(amountTextField.snp.leading).offset(-16)
            $0.width.equalTo(contentView.snp.width).multipliedBy(0.5)
        }
        
        amountTextField.snp.makeConstraints {
            $0.trailing.equalTo(contentView.snp.trailing).offset(-16)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.width.equalTo(100)
        }
    }
}
