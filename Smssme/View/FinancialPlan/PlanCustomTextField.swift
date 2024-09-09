//
//  PlanCustomTextField.swift
//  Smssme
//
//  Created by 임혜정 on 8/28/24.
//

import UIKit

// MARK: - bottomBorder 커스텀 텍스트필드
class AmountTextField {
    static let shared = CustomTextField()
    private init () {}
    static func createTextField(keyboard: UIKeyboardType, currencyText: String) -> CustomTextField {
        let textField = CustomTextField()
        textField.textColor = UIColor.black
        textField.borderStyle = .none
        textField.keyboardType = keyboard
        textField.clipsToBounds = false
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "입력완료", style: .done, target: textField, action: #selector(textField.dismissKeyboard))
        toolbar.setItems([doneButton], animated: true)
        textField.inputAccessoryView = toolbar
        
        let currencyLabel = UILabel()
        currencyLabel.text = currencyText
        currencyLabel.font = textField.font
        currencyLabel.textColor = .black
        currencyLabel.sizeToFit()
        
        textField.rightView = currencyLabel
        textField.rightViewMode = .always
        
        return textField
    }
    
    static func setValue(for textField: CustomTextField, value: Int) {
        textField.text = "\(value)"
    }
}


class DateTextField: CustomTextField {
    private let datePicker = UIDatePicker()
    private let dateFormatter = DateFormatter()
    
    var date: Date? {
        didSet {
            updateText()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextField()
    }
    
    private func setupTextField() {
        textColor = .black
        borderStyle = .none
        clipsToBounds = false
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        inputView = datePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "입력완료", style: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([doneButton], animated: true)
        inputAccessoryView = toolbar
        
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        // 초기 날짜 설정
        date = Date()
    }
    
    @objc private func dateChanged() {
        date = datePicker.date
    }
    
    private func updateText() {
        if let date = date {
            text = dateFormatter.string(from: date)
        } else {
            text = nil
        }
    }
}

class GoalDateTextField {
    static func createTextField() -> DateTextField {
        return DateTextField()
    }
    static func setValue(for textField: CustomTextField, value: String) {
        textField.text = "\(value)"
    }
}

class CustomTextField: UITextField {
    private let bottomBorder = CALayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBottomBorder()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBottomBorder()
    }
    
    private func setupBottomBorder() {
        layer.addSublayer(bottomBorder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateBottomBorder()
    }
    
    private func updateBottomBorder() {
        bottomBorder.frame = CGRect(x: 0.0, y: self.frame.height - 1, width: self.frame.width, height: 1.0)
        bottomBorder.backgroundColor = UIColor.black.cgColor
    }
    
    @objc func dismissKeyboard() {
        resignFirstResponder()
    }
}

