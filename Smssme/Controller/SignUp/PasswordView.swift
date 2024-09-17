//
//  PasswordView.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/8/24.
//

import UIKit

class PasswordView: UIView {
    private let commonHeight = 50
    private let loginView = LoginView()
    
    //MARK: - 회원가입 진행 상황 Progress Bar
    var progressBar: UIProgressView = {
        let bar = UIProgressView()
        bar.progress = 0.4
        return bar
    }()
    
    //MARK: - 비밀번호
    let passwordLabel = SmallTitleLabel().createLabel(with: "비밀번호", color: .black)
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호는 최소 6자 이상 입력"
        textField.textColor = .black
        textField.backgroundColor = .clear
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.systemGray5.cgColor
        textField.layer.cornerRadius = 8
        textField.keyboardType = .emailAddress
        textField.clearButtonMode = .always
        textField.addLeftPadding()
        textField.isSecureTextEntry = true
        textField.textContentType = .oneTimeCode
        return textField
    }()
    
    // 숫자, 영문, 특수문자 8-16자 입력
    // 1개 이상의 영문, 숫자, 특수문자를 포함
    let passwordErrorLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.isHidden = false
        return label
    }()
    
    // 비밀번호 재확인
    let passwordCheckTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호 재확인"
        textField.textColor = .black
        textField.backgroundColor = .clear
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.systemGray5.cgColor
        textField.layer.cornerRadius = 8
        textField.keyboardType = .emailAddress
        textField.clearButtonMode = .always
        textField.addLeftPadding()
        textField.isSecureTextEntry = true
        textField.textContentType = .oneTimeCode
        return textField
    }()
    
    let passwordCheckErrorLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 16)
        label.isHidden = false
        return label
    }()
    
    //MARK: - 다음 버튼
    
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
        
        loginView.setPasswordEyeButton(textField: passwordTextField)
        loginView.setPasswordEyeButton(textField: passwordCheckTextField)
        
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
         passwordLabel,
         passwordTextField,
         passwordErrorLabel,
         passwordCheckTextField,
         passwordCheckErrorLabel,
         nextButton].forEach {self.addSubview($0)}
    }
    
    private func setupLayout() {
        progressBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(5)
            $0.horizontalEdges.equalToSuperview()
        }
        
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(progressBar.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(commonHeight)
        }
        
        passwordErrorLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(36)
        }
        
        passwordCheckTextField.snp.makeConstraints {
            $0.top.equalTo(passwordErrorLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(commonHeight)
        }
        
        passwordCheckErrorLabel.snp.makeConstraints {
            $0.top.equalTo(passwordCheckTextField.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(36)
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
