//
//  EmailView.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/8/24.
//

import UIKit

class EmailView: UIView {
    private let commonHeight = 50
    
    //MARK: - 회원가입 진행 상황 Progress Bar
    var progressBar: UIProgressView = {
        let bar = UIProgressView()
        bar.progress = 0.4
        return bar
    }()
    
    //MARK: - 상단 제목 라벨
    private var titleLabel = LabelFactory.titleLabel()
        .setText("실제 사용 중인 \n이메일 주소를 입력해 주세요.")
        .build()
    private let subTitleLabel = LabelFactory.bodyLabel().setText("비밀번호 재설정 시 인증 메일이 전송됩니다.").setColor(.bodyGray).build()

    //MARK: - 아이디(이메일)
    let emailLabel = LabelFactory.titleLabel().setText("이메일 주소").setFont(.boldSystemFont(ofSize: 16)).build()
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "예) money@smssme.com"
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
    
    let emailErrorLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .red
        label.font = .systemFont(ofSize: 16)
        label.isHidden = false // 기본적으로 숨김 처리
        return label
    }()
    
    let checkEmailButton = BaseButton().createButton(text: "중복확인", color: .systemBlue, textColor: .white)
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호를 입력하세요"
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
        textField.isHidden = true
        return textField
    }()
    
    
    //MARK: - 다음 버튼
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
        
        [progressBar,
         titleLabel,
         subTitleLabel,
         emailLabel,
         emailTextField,
         checkEmailButton,
         emailErrorLabel,
         passwordTextField,
         nextButton
        ].forEach {self.addSubview($0)}
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
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(30)
        }
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(10)
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
        
        emailErrorLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(10)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(36)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailErrorLabel.snp.bottom).offset(10)
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
