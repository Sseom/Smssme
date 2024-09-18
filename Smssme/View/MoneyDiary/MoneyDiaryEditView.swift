//
//  MoneyDiaryEditView.swift
//  Smssme
//
//  Created by 전성진 on 8/30/24.
//

import SnapKit
import UIKit

class MoneyDiaryEditView: UIView {
    //MARK: - Factory Component Properties
    private let dateLabel = ContentLabel().createLabel(with: "수입일", color: .black)
    private let priceLabel = ContentLabel().createLabel(with: "수입금액", color: .black)
    private let titleLabel = ContentLabel().createLabel(with: "수입명", color: .black)
    private let categoryLabel = ContentLabel().createLabel(with: "카테고리", color: .black)
    private let noteLabel = ContentLabel().createLabel(with: "메모", color: .black)
    
    let priceTextField = AmountTextField.createTextField(keyboard: .numberPad, currencyText: "원")
    let titleTextField = AmountTextField.createTextField(keyboard: .default, currencyText: "")
    let categoryTextField = AmountTextField.createTextField(keyboard: .default, currencyText: "")
//    let noteTextField = BaseTextField().createTextField(placeholder: "메모", textColor: .black)
    
    let cancelButton = BaseButton().createButton(text: "취소", color: .lightGray, textColor: .white)
    let saveButton = BaseButton().createButton(text: "저장", color: .systemBlue, textColor: .white)
    
    //MARK: - Component Properties
    lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["지출", "수입"])
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(viewChange(segment:)), for: .valueChanged)
        return segmentControl
    }()
    
    private let contentsView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let contentsVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
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
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        
        return datePicker
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
        
        priceTextField.delegate = self
        noteTextField.delegate = self
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    

    
    private func setupUI() {
        [segmentControl, dateLabel, datePicker, priceLabel, priceTextField, titleLabel, titleTextField, categoryLabel, categoryTextField, noteLabel, noteTextField, cancelButton, saveButton].forEach {
            self.addSubview($0)
        }
        
        // Auto Layout Constraints
        segmentControl.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(20)
            $0.left.right.equalToSuperview().inset(30)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(segmentControl.snp.bottom).offset(20)
            $0.left.equalToSuperview().inset(30)
            $0.width.equalTo(70)
            $0.height.equalTo(34)
        }
        
        datePicker.snp.makeConstraints {
            $0.centerY.equalTo(dateLabel)
            $0.left.equalTo(dateLabel.snp.right).offset(10)
            $0.right.equalToSuperview().inset(30)
            $0.height.equalTo(40)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(20)
            $0.left.equalToSuperview().inset(30)
            $0.width.equalTo(70)
            $0.height.equalTo(34)
        }
        
        priceTextField.snp.makeConstraints {
            $0.centerY.equalTo(priceLabel)
            $0.left.equalTo(priceLabel.snp.right).offset(10)
            $0.right.equalToSuperview().inset(30)
            $0.height.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(20)
            $0.left.equalToSuperview().inset(30)
            $0.width.equalTo(70)
            $0.height.equalTo(34)
        }
        
        titleTextField.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.left.equalTo(titleLabel.snp.right).offset(10)
            $0.right.equalToSuperview().inset(30)
            $0.height.equalTo(40)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.left.equalToSuperview().inset(30)
            $0.width.equalTo(70)
            $0.height.equalTo(34)
        }
        
        categoryTextField.snp.makeConstraints {
            $0.centerY.equalTo(categoryLabel)
            $0.left.equalTo(categoryLabel.snp.right).offset(10)
            $0.right.equalToSuperview().inset(30)
            $0.height.equalTo(40)
        }
        
        noteLabel.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(20)
            $0.left.equalToSuperview().inset(30)
            $0.width.equalTo(70)
            $0.height.equalTo(34)
        }
        
        noteTextField.snp.makeConstraints {
            $0.top.equalTo(noteLabel)
            $0.left.equalTo(noteLabel.snp.right).offset(10)
            $0.right.equalToSuperview().inset(30)
            $0.height.equalTo(300)
        }
        
        cancelButton.snp.makeConstraints {
            $0.top.equalTo(noteTextField.snp.bottom).offset(30)
            $0.left.equalToSuperview().inset(30)
            $0.right.equalTo(self.snp.centerX).offset(-10)
            $0.height.equalTo(40)
        }
        
        saveButton.snp.makeConstraints {
            $0.top.equalTo(noteTextField.snp.bottom).offset(30)
            $0.left.equalTo(self.snp.centerX).offset(10)
            $0.right.equalToSuperview().inset(30)
            $0.height.equalTo(40)
        }
        dateLabel.text = "지출일"
        priceLabel.text = "지출금액"
        titleLabel.text = "지출명"
        titleTextField.placeholder = "지출명"
    }
    
    //MARK: - Objc
    //FIXME: View가 바뀌는 이벤트라 View에 넣는게 맞지 않을까
    @objc func viewChange(segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            dateLabel.text = "지출일"
            priceLabel.text = "지출금액"
            titleLabel.text = "지출명"
            titleTextField.placeholder = "지출명"
        } else {
            dateLabel.text = "수입일"
            priceLabel.text = "수입금액"
            titleLabel.text = "수입명"
            titleTextField.placeholder = "수입명"
        }
    }
    
    @objc func touch() {
        self.endEditing(true)
    }
}

extension MoneyDiaryEditView: UITextViewDelegate {
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

extension MoneyDiaryEditView: UITextFieldDelegate {
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

