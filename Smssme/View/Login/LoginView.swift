//
//  LoginView.swift
//  Smssme
//
//  Created by ahnzihyeon on 8/27/24.
//

import SnapKit
import UIKit

final class LoginView: UIView {
    // 아이디, 비밀번호, 로그인 버튼의 공통된 높이
    private let textFieldHeight = 48
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "loginImage")
        return imageView
    }()
    
    var emailTextField: UITextField = {
        var textField = UITextField()
        textField.placeholder = "아이디(이메일)을 입력해주세요."
        textField.textColor = .black
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5
        textField.keyboardType = UIKeyboardType.emailAddress
        textField.clearButtonMode = .always
        return textField
    }()
    
    var passwordTextField: UITextField = {
        var textField = UITextField()
        textField.placeholder = "비밀번호를 입력해주세요."
        textField.textColor = .black
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5
        textField.clearButtonMode = .always
        textField.keyboardType = UIKeyboardType.emailAddress
        textField.isSecureTextEntry = true
        textField.textContentType = .oneTimeCode
        return textField
    }()

    let loginButton = BaseButton().createButton(text: "로그인", color: UIColor.systemBlue, textColor: UIColor.white)
    
    // 아이디, 비밀번호, 로그인 stackView
    private var loginStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let signupButton = BaseButton().createButton(text: "회원가입", color: #colorLiteral(red: 0.9121415615, green: 0.9536862969, blue: 1, alpha: 1), textColor: UIColor.systemBlue)
    
    let unLoginButton = BaseButton().createButton(text: "로그인 없이 둘러보기", color: .clear, textColor: UIColor(hex: "#333333"))
    
    // 빈 화면 터치 시 키보드 내려감
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Auto Layout
    private func configureUI() {
        self.backgroundColor = .white
        
        [emailTextField, passwordTextField].forEach {loginStackView.addArrangedSubview($0)}
        
        [logoImageView, loginStackView,loginButton, signupButton, unLoginButton].forEach {self.addSubview($0)}
        
    }
    
    private func setupLayout() {
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16)
            $0.leading.equalToSuperview().offset(40)
            $0.trailing.equalToSuperview().offset(-40)
            $0.height.equalTo(logoImageView.snp.width)
        }
        
        loginStackView.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(textFieldHeight * 2 + 16)
            $0.horizontalEdges.equalToSuperview().inset(30)
        }
        
        loginButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(loginStackView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.height.equalTo(textFieldHeight)
        }
        
        signupButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(loginButton.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.height.equalTo(textFieldHeight)
        }
        
        unLoginButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(signupButton.snp.bottom).offset(24)
        }
    }
    
    @objc
    func passwordSecureMode() {
        passwordTextField.isSecureTextEntry.toggle()
    }
}
