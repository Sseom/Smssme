//
//  EmailView.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/8/24.
//

import UIKit

class EmailView: UIView {
    
    //상단 제목 라벨
    private var titleLabel = LargeTitleLabel().createLabel(with: "회원가입", color: UIColor.black)
    
    //MARK: - 아이디(이메일)
    let emailLabel = SmallTitleLabel().createLabel(with: "이메일 주소를 \n입력해주세요.", color: .black)
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "예) money@smssme.com"
        textField.frame.size.height = 48
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
    
    // 이메일 중복체크
    lazy var emailCheckButton: UIButton = {
        let button = UIButton()
        button.setTitle("중복", for: .normal)
        button.backgroundColor = .systemGray5
        return button
    }()
    
    let emailErrorLabel: UILabel = {
        let label = UILabel()
        label.text = "유효한 이메일을 입력하세요."
        label.textColor = .red
        label.font = .systemFont(ofSize: 14)
        label.isHidden = true // 기본적으로 숨김 처리
        return label
    }()
    
    //MARK: - 비밀번호
    let passwordLabel = SmallTitleLabel().createLabel(with: "비밀번호", color: .black)
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호를 입력해주세요."
        textField.textColor = UIColor.lightGray
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5
        textField.clearButtonMode = .always
        textField.textContentType = .oneTimeCode
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let passwordErrorLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호는 최소 8자 이상이어야 합니다."
        label.textColor = .red
        label.font = .systemFont(ofSize: 14)
        label.isHidden = true // 기본적으로 숨김 처리
        return label
    }()
    
    // 비밀번호 재확인
    private lazy var passwordCheckTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호 재확인"
        textField.textColor = UIColor.lightGray
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5
        textField.clearButtonMode = .always
        textField.isSecureTextEntry = true
        textField.textContentType = .oneTimeCode
        return textField
    }()
    
    let passwordCheckErrorLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호가 일치하지 않습니다."
        label.textColor = .red
        label.font = .systemFont(ofSize: 14)
        label.isHidden = true // 기본적으로 숨김 처리
        return label
    }()
    
    //MARK: - 다음 버튼
    
    //다음 버튼
    var nextButton = BaseButton().createButton(text: "다음", color: UIColor.systemBlue, textColor: UIColor.white)
    
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - func
    private func configureUI() {
        self.backgroundColor = .white
        
        // 스크롤뷰에서 빈 화면터치 시 키보드 내려감
//        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.touch))
//        recognizer.numberOfTapsRequired = 1
//        recognizer.numberOfTouchesRequired = 1
        
        [titleLabel,
         emailLabel,
         emailTextField,
         passwordLabel,
         passwordTextField,
         passwordCheckTextField].forEach {self.addSubview($0)}
    }
    
    private func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(80)
            $0.leading.equalToSuperview().inset(30)
        }
        
        emailLabel.snp.makeConstraints { make in
            
            
        }
        
        emailTextField.snp.makeConstraints { make in
            
        }
        
        emailErrorLabel.snp.makeConstraints { make in
            <#code#>
        }
 
    }
    
    // 빈 화면 터치 시 키보드 내려감
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    //MARK: - @objc
//    @objc func touch() {
//        self.endEditing(true)
//    }
    
}
