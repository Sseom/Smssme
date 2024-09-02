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
    
    // 로고 이미지
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    // 아이디(이메일) 입력
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
    
    // 비밀번호 입력
    var passwordTextField: UITextField = {
        var textField = UITextField()
        textField.placeholder = "비밀번호를 입력해주세요."
        textField.textColor = .black
        textField.backgroundColor = .clear
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5
        textField.clearButtonMode = .always
        return textField
    }()
    
    // 자동로그인 체크박스
    var autoLoginCheckBox: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
           button.setBackgroundImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        button.tag = 1
        return button
    }()
    
    let autoLoginLabel: UILabel = {
        let label = UILabel()
        label.text = "자동로그인"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        return label
    }()
    
    let autoLoginStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    
    // 아이디 저장 체크박스
    var rememberIDCheckBox: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
           button.setBackgroundImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        button.tag = 2
        return button
    }()
    
    let rememberIDLabel: UILabel = {
        let label = UILabel()
        label.text = "아이디저장"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        return label
    }()
    
    let rememberIDStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    // 자동로그인 스택뷰와 아이디 저장 스택뷰를 담는 스택뷰
    let loginOptionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        return stackView
    }()
    
    // 로그인 버튼
    let loginButton = BaseButton().createButton(text: "로그인", color: UIColor.systemBlue, textColor: UIColor.white)
    
    // 아이디, 비밀번호, 로그인 stackView
    private var loginStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    //회원가입 버튼
    let signupButton = BaseButton().createButton(text: "회원가입", color: #colorLiteral(red: 0.9121415615, green: 0.9536862969, blue: 1, alpha: 1), textColor: UIColor.systemBlue)
    
    
    //비회원 로그인
    let unLoginButton = BaseButton().createButton(text: "로그인 없이 둘러보기", color: .clear, textColor: UIColor.gray)
    

    
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
    
    
    //MARK: - setupUI
    private func configureUI() {
        self.backgroundColor = .white
        
        // 자동로그인, 아이디 저장 추가
        [autoLoginCheckBox, autoLoginLabel].forEach {autoLoginStackView.addArrangedSubview($0)}
        
        [rememberIDCheckBox, rememberIDLabel].forEach {rememberIDStackView.addArrangedSubview($0)}
        
        [autoLoginStackView, rememberIDStackView].forEach { loginOptionsStackView.addArrangedSubview($0) }
        
        // loginStackView에 추가
        [emailTextField, passwordTextField].forEach {loginStackView.addArrangedSubview($0)}
        
        // view에 추가
        [logoImageView, loginStackView, loginOptionsStackView,loginButton, signupButton, unLoginButton].forEach {self.addSubview($0)}
        
    }
    
    private func setupLayout() {
        // 로고 이미지
        logoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide).inset(100)
            $0.width.height.equalTo(100)
        }
        
        // 아이디, 비밀번호 스택뷰
        loginStackView.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(50)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(textFieldHeight * 2 + 16) //스택뷰 spacing 간격 18
            $0.horizontalEdges.equalToSuperview().inset(30)
        }
        
        // 체크박스
        autoLoginCheckBox.snp.makeConstraints { $0.height.width.equalTo(24)}
        rememberIDCheckBox.snp.makeConstraints { $0.height.width.equalTo(24)}
        
        // 로그인 옵션 스택뷰
        loginOptionsStackView.snp.makeConstraints {
            $0.top.equalTo(loginStackView.snp.bottom).offset(16)
            $0.leading.equalTo(loginStackView.snp.leading)
            $0.trailing.equalTo(loginStackView.snp.trailing).inset(110)
        }
        
        // 로그인 버튼
        loginButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(loginOptionsStackView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.height.equalTo(textFieldHeight)
        }
        
        // 회원가입 버튼
        signupButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(loginButton.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.height.equalTo(textFieldHeight)
        }
        
        // 비회원 로그인
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
