//
//  ResetPassword.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/17/24.
//

import UIKit

class ResetPasswordView: UIView {
    private let commonHeight = 50

    //MARK: - 상단 제목 라벨
    private var titleLabel = LargeTitleLabel().createLabel(with: "가입했던 이메일을 입력해주세요.", color: UIColor.black)
    private let subTitleLabel = SmallTitleLabel().createLabel(with: "비밀번호 재설정 메일을 보내드립니다.", color: .lightGray)
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "예) money@smssme.com"
        textField.textColor = .black
        textField.backgroundColor = .clear
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.systemGray5.cgColor
        textField.layer.cornerRadius = 8
        textField.keyboardType = .emailAddress
        textField.clearButtonMode = .always
        textField.addLeftPadding()
        return textField
    }()
//    
//    let emailErrorLabel: UILabel = {
//        let label = UILabel()
//        label.text = ""
//        label.textColor = .red
//        label.font = .systemFont(ofSize: 16)
//        label.isHidden = false // 기본적으로 숨김 처리
//        return label
//    }()
    
    let checkEmailButton = BaseButton().createButton(text: "인증하기", color: .systemBlue, textColor: .white)
    
    //MARK: - 비밀번호 인증 버튼
    var sendResetPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("비밀번호 인증", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.isHidden = false
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
        
        [titleLabel,
         emailTextField,
         subTitleLabel,
         checkEmailButton,
         sendResetPasswordButton
        ].forEach {self.addSubview($0)}
    }
    
    private func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(25)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(30)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(commonHeight)
        }
        
        checkEmailButton.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.top)
            $0.leading.equalTo(emailTextField.snp.trailing).offset(5)
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(30)
            $0.width.equalTo(80)
            $0.height.equalTo(commonHeight)
        }
        
        sendResetPasswordButton.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(280)
            $0.height.equalTo(commonHeight)
        }
    }
}
