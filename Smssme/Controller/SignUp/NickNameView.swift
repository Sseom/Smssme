//
//  NickNameView.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/8/24.
//

import UIKit

class NickNameView: UIView {
    private let commonHeight = 50
    
    //상단 제목 라벨
    private var titleLabel = LargeTitleLabel().createLabel(with: "닉네임과 생년월일", color: UIColor.black)
    
    
    //MARK: - 닉네임
    let nicknameLabel = SmallTitleLabel().createLabel(with: "닉네임", color: .black)
    
    var nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임(10자 이내)"
        textField.textColor = .black
        textField.backgroundColor = .clear
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.systemGray5.cgColor
        textField.layer.cornerRadius = 8
        textField.clearButtonMode = .always
        textField.addLeftPadding()
        return textField
    }()
    
    
    //MARK: - 생년월일
    let birthdayLabel = SmallTitleLabel().createLabel(with: "생년월일", color: .black)
    
    let birthdayTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "생년월일 8자리 입력(예: 2000/01/01)"
        textField.textColor = .black
        textField.backgroundColor = .clear
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.systemGray5.cgColor
        textField.layer.cornerRadius = 8
        textField.clearButtonMode = .always
        textField.addLeftPadding()
        return textField
    }()
    
    //생년월일 데이트피커뷰
    var datePickerView = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let temp = dateFormatter.date(from: "2000/01/01")
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.date = temp ?? Date()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko-KR")
        return datePicker
    }()
    
    //다음 버튼
    var nextButton = BaseButton().createButton(text: "다음", color: UIColor.systemBlue, textColor: UIColor.white)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        setupLayout()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - func
    private func configureUI() {
        self.backgroundColor = .white
        [titleLabel,
         nicknameLabel,
         nicknameTextField,
         birthdayLabel,
         birthdayTextField,
         nextButton].forEach {self.addSubview($0)}
    }
    
    private func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(24)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(commonHeight)
        }
        
        birthdayLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        birthdayTextField.snp.makeConstraints {
            $0.top.equalTo(birthdayLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(commonHeight)
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(commonHeight)
        }
    }
}
