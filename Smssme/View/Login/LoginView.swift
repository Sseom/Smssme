//
//  LoginView.swift
//  Smssme
//
//  Created by ahnzihyeon on 8/27/24.
//

import UIKit
import SnapKit

final class LoginView: UIView {
    
    //아이디, 비밀번호, 로그인 버튼의 공통된 높이
    private let textFieldHeight = 48
    
    // 아이디 입력
    private var userIdTextField: UITextField = {
        var textField = UITextField()
        textField.placeholder = "아이디"
        textField.textColor = .black
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    // 비밀번호 입력
    private var passwordTextField: UITextField = {
        var textField = UITextField()
        textField.placeholder = "비밀번호"
        textField.textColor = .black
        textField.backgroundColor = .clear
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    // 로그인 버튼
//    private let loginButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("로그인", for: .normal)
//        button.backgroundColor = .systemBlue
//        button.layer.cornerRadius = 5
//        return button
//    }()
    
    private let loginButton = BaseButton().createButton(text: "로그인", color: UIColor.systemBlue, textColor: UIColor.white)
    
    // 아이디, 비밀번호, 로그인 stackView
    private var loginStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 18
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    //회원가입 버튼
    private let joinButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.9121415615, green: 0.9536862969, blue: 1, alpha: 1)
        button.layer.cornerRadius = 5
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
    
    //MARK: -func
    private func configureUI() {
        self.backgroundColor = .white
        
        [userIdTextField, passwordTextField, loginButton].forEach {loginStackView.addArrangedSubview($0)}
        
        [loginStackView, joinButton].forEach {self.addSubview($0)}
        
    }
    
    private func setupLayout() {
        loginStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(textFieldHeight * 3 + 36) //스택뷰 spacing 간격 18
            $0.horizontalEdges.equalToSuperview().inset(30)
        }
        
        joinButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(loginStackView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.height.equalTo(textFieldHeight)
        }

    }
    
    
    //MARK: -@objc
    @objc
    func passwordSecureMode() {
        //.isSecureTextEntry.toggle()
    }
}
