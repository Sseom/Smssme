//
//  AssetsEditView.swift
//  Smssme
//
//  Created by 전성진 on 8/30/24.
//

import SnapKit
import UIKit

class AssetsEditView: UIView {
    //MARK: - Factory Component Properties
    private let categoryLabel = ContentLabel().createLabel(with: "카테고리", color: .black)
    private let titleLabel = ContentLabel().createLabel(with: "항목", color: .black)
    private let amountLabel = ContentLabel().createLabel(with: "금액", color: .black)
    private let noteLabel = ContentLabel().createLabel(with: "메모", color: .black)
    
    let categoryTextField = AmountTextField.createTextField(keyboard: .default, currencyText: "")
    let titleTextField = AmountTextField.createTextField(keyboard: .default, currencyText: "")
    let amountTextField = AmountTextField.createTextField(keyboard: .numberPad, currencyText: "원")
    
    let cancelButton = BaseButton().createButton(text: "취소", color: .lightGray, textColor: .white)
    let saveButton = BaseButton().createButton(text: "저장", color: .systemBlue, textColor: .white)
    
    //MARK: - Component Properties
    
    let noteTextField: UITextView = {
        let textView = UITextView()
        textView.text = "메모"
        textView.textColor = .systemGray4
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.borderColor = UIColor.systemGray5.cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 6.0
        return textView
    }()
    
    let deleteButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        barButton.image = UIImage(systemName: "trash")
        return barButton
    }()
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        return stackView
    }()
        
    // MARK: - View Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        // 터치시 키보드 내림
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(touch))
        self.addGestureRecognizer(recognizer)
        amountTextField.delegate = self
        noteTextField.delegate = self
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    // MARK: - Private Method
    
    private func setupUI() {
        [categoryLabel,
         categoryTextField,
         titleLabel,
         titleTextField,
         amountLabel,
         amountTextField,
         noteLabel,
         noteTextField,
         buttonStackView].forEach {
            self.addSubview($0)
        }
        
        [cancelButton, saveButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(20)
            $0.left.equalTo(self.safeAreaLayoutGuide).offset(40)
            $0.width.equalTo(60)
        }
        
        categoryTextField.snp.makeConstraints {
            $0.left.equalTo(categoryLabel.snp.right).offset(15)
            $0.right.equalTo(self.safeAreaLayoutGuide).offset(-40)
            $0.centerY.equalTo(categoryLabel.snp.centerY)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(25)
            $0.left.equalTo(self.safeAreaLayoutGuide).offset(40)
            $0.width.equalTo(60)
        }
        
        titleTextField.snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.right).offset(15)
            $0.right.equalTo(self.safeAreaLayoutGuide).offset(-40)
            $0.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        amountLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(25)
            $0.left.equalTo(self.safeAreaLayoutGuide).offset(40)
            $0.width.equalTo(60)
        }
        
        amountTextField.snp.makeConstraints {
            $0.left.equalTo(amountLabel.snp.right).offset(15)
            $0.right.equalTo(self.safeAreaLayoutGuide).offset(-40)
            $0.centerY.equalTo(amountLabel.snp.centerY)
        }
        
        noteLabel.snp.makeConstraints {
            $0.top.equalTo(amountLabel.snp.bottom).offset(25)
            $0.left.equalTo(self.safeAreaLayoutGuide).offset(40)
            $0.width.equalTo(60)
        }
        
        noteTextField.snp.makeConstraints {
            $0.top.equalTo(noteLabel.snp.top)
            $0.left.equalTo(noteLabel.snp.right).offset(15)
            $0.right.equalTo(self.safeAreaLayoutGuide).offset(-40)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(noteTextField.snp.bottom).offset(30)
            $0.left.right.bottom.equalTo(self.safeAreaLayoutGuide).inset(40)
            $0.height.equalTo(40)
        }
    }
    
    //MARK: - Objc
    @objc func touch() {
        self.endEditing(true)
    }

}

extension AssetsEditView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.systemGray4 {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "메모"
            textView.textColor = .systemGray4
        }
    }
}

extension AssetsEditView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) && string != "" {
            return false
        }
        
        var currentText = textField.text ?? ""
        
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if currentText == "0" && string != "" {
            currentText = string
        } else {
            currentText = newText
        }
        
        let formattedText = formatNumberWithComma(currentText)
        
        textField.text = formattedText
        
        return false
    }
    
    private func formatNumberWithComma(_ number: String) -> String {
        let numberString = number.replacingOccurrences(of: ",", with: "")
        
        if let numberValue = Int(numberString) {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            return numberFormatter.string(from: NSNumber(value: numberValue)) ?? number
        }
        
        return number
    }
}

