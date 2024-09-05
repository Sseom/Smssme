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
//    let noteTextField = BaseTextField().createTextField(placeholder: "메모", textColor: .black)
    
    let cancelButton = BaseButton().createButton(text: "취소", color: .lightGray, textColor: .white)
    let saveButton = BaseButton().createButton(text: "저장", color: .systemBlue, textColor: .white)
    
    //MARK: - Component Properties
    private let contentsView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let contentsVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
//        stackView.backgroundColor = .darkGray
//        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 50, right: 10)
//        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
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
    private func setHorizontalStackView(components: [UIView], distrbution: UIStackView.Distribution) {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = distrbution
        components.forEach {
            stackView.addArrangedSubview($0)
        }
        
        contentsVerticalStackView.addArrangedSubview(stackView)
    }
    
    private func setupUI() {
        [contentsView].forEach {
            self.addSubview($0)
        }
        
        [contentsVerticalStackView].forEach {
            contentsView.addSubview($0)
        }
        
        // horizontalStackView 세팅
        setHorizontalStackView(components: [categoryLabel, categoryTextField], distrbution: .fill)
        setHorizontalStackView(components: [titleLabel, titleTextField], distrbution: .fill)
        setHorizontalStackView(components: [amountLabel, amountTextField], distrbution: .fill)
        setHorizontalStackView(components: [noteLabel, noteTextField], distrbution: .fill)
        setHorizontalStackView(components: [cancelButton, saveButton], distrbution: .fillEqually)
        
        contentsView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        contentsVerticalStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(30)
        }
        
        // label 길이 정렬
        [categoryLabel,
         amountLabel,
         titleLabel].forEach {
            $0.snp.makeConstraints {
                $0.width.equalTo(70)
                $0.height.equalTo(34)
            }
        }
        
        noteLabel.snp.makeConstraints {
            $0.width.equalTo(70)
        }
        
        cancelButton.snp.makeConstraints {
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

