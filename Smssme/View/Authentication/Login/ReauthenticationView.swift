//
//  ReauthenticationView.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/19/24.
//

import UIKit

class ReauthenticationView: UIView {
    private let commonHeight = 50
    
    //MARK: - 상단 제목 라벨
    private var titleLabel = LargeTitleLabel().createLabel(with: "본인인증을 위해 재로그인해주세요.", color: UIColor.black)
    
    //MARK: - 아이디(이메일)
//    let emailLabel = SmallTitleLabel().createLabel(with: "이메일", color: .black)
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이메일을 입력해주세요"
        textField.textColor = .black
        textField.backgroundColor = .clear
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.systemGray5.cgColor
        textField.layer.cornerRadius = 8
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.clearButtonMode = .always
        textField.addLeftPadding()
        return textField
    }()
    
//    let emailErrorLabel: UILabel = {
//        let label = UILabel()
//        label.text = ""
//        label.textColor = .red
//        label.font = .systemFont(ofSize: 16)
//        label.isHidden = false // 기본적으로 숨김 처리
//        return label
//    }()
    
    //MARK: - 비밀번호
//    let passwordLabel = SmallTitleLabel().createLabel(with: "비밀번호", color: .black)
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호를 입력해주세요."
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
    let errorLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.isHidden = false
        return label
    }()
    
    //MARK: - 확인 버튼
    var deleteUserButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원탈퇴", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGray5
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.isEnabled = false
        return button
    }()
    
    
    //MARK: - init
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
        
        // 빈 화면터치 시 키보드 내려감
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.touch))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        
        self.addGestureRecognizer(recognizer)
        
        [titleLabel,
//         emailLabel,
         emailTextField,
//         emailErrorLabel,
//         passwordLabel,
         passwordTextField,
         errorLabel,
         deleteUserButton
        ].forEach {self.addSubview($0)}
    }
    
    private func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(20)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(30)
        }

//        emailLabel.snp.makeConstraints {
//            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
//            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
//        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(commonHeight)
        }
        
//        emailErrorLabel.snp.makeConstraints {
//            $0.top.equalTo(emailTextField.snp.bottom).offset(10)
//            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(36)
//        }
        
//        passwordLabel.snp.makeConstraints {
//            $0.top.equalTo(emailErrorLabel.snp.bottom).offset(20)
//            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
//        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(commonHeight)
        }
        
        errorLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(36)
        }
        
        deleteUserButton.snp.makeConstraints {
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
