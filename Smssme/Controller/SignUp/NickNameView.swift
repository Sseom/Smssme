//
//  NickNameView.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/8/24.
//

import UIKit

class NickNameView: UIView {
    private let commonHeight = 50
    
    //MARK: - 회원가입 진행 상황 Progress Bar
    var progressBar: UIProgressView = {
        let bar = UIProgressView()
        bar.setProgress(0.7, animated: true)
        return bar
    }()
    
    //MARK: - 상단 제목 라벨
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
    
    let nicknameErrorLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임을 2-10자로 입력해주세요"
        label.textColor = .red
        label.font = .systemFont(ofSize: 16)
        label.isHidden = false // 기본적으로 숨김 처리
        return label
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
        textField.tintColor = .clear // 커서 표시 해제
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
    var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGray5
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.isEnabled = false
        return button
    }()
    
    
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
        
        // 스크롤뷰에서 빈 화면터치 시 키보드 내려감
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.touch))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        
        self.addGestureRecognizer(recognizer)
        
        [progressBar,
         titleLabel,
         nicknameLabel,
         nicknameTextField,
         nicknameErrorLabel,
         birthdayLabel,
         birthdayTextField,
         nextButton].forEach {self.addSubview($0)}
    }
    
    private func setupLayout() {
        progressBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(5)
            $0.horizontalEdges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(progressBar.snp.bottom).offset(20)
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
        
        nicknameErrorLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(36)
        }
        
        birthdayLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameErrorLabel.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        birthdayTextField.snp.makeConstraints {
            $0.top.equalTo(birthdayLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(commonHeight)
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(280)
            $0.height.equalTo(commonHeight)
        }
    }
    
    //MARK: - @objc
    // 빈 화면 터치 시 키보드 내려감
    @objc func touch() {
        self.endEditing(true)
    }
}
