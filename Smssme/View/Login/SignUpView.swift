//
//  SignUpView.swift
//  Smssme
//
//  Created by ahnzihyeon on 8/28/24.
//

import UIKit

final class SignUpView: UIView {
    
    // 텍스트필드의 공통된 높이
    private let textFieldHeight = 48
    
    //상단 제목 라벨
    private var titleLabel = LargeTitleLabel().createLabel(with: "회원가입", color: UIColor.black)
    
    //아이디(이메일)
    let emaiTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "아이디(이메일)"
        textField.textColor = UIColor.lightGray
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5
        textField.keyboardType = UIKeyboardType.emailAddress
        textField.clearButtonMode = .always
        return textField
    }()
    
    //비밀번호
    var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호"
        textField.textColor = UIColor.lightGray
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5
        textField.clearButtonMode = .always
        textField.isSecureTextEntry = true
        return textField
    }()
    
    //비밀번호 재확인
    private var passwordCheckTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호 재확인"
        textField.textColor = UIColor.lightGray
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5
        textField.isSecureTextEntry = true
        return textField
    }()
    
    //닉네임
    var nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임"
        textField.textColor = UIColor.lightGray
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    //생년월일 -> birthdatePicker 사용할지
    let birthdayTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "생년월일 8자리 입력(예:  1900/01/31)"
        textField.textColor = UIColor.lightGray
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5
        textField.keyboardType = UIKeyboardType.phonePad
        return textField
    }()
    
    //성별 선택
    var genderSegment: UITextField = {
        let textField = UITextField()
        textField.placeholder = "성별"
        textField.textColor = UIColor.lightGray
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    //소득 선택 -> 클릭 하면 하단에 모달로 자동으로 뜨게?
    var incomePicker: UITextField = {
        let textField = UITextField()
        textField.placeholder = "소득"
        textField.textColor = UIColor.lightGray
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    //지역 선택
    var locationPicker: UITextField = {
        let textField = UITextField()
        textField.placeholder = "지역"
        textField.textColor = UIColor.lightGray
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    //회원가입 버튼
    var signupButton = BaseButton().createButton(text: "회원가입", color: UIColor.systemBlue, textColor: UIColor.white)
    
    
    let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 18
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 빈 화면 터치 시 키보드 내려감ㅋ
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          self.endEditing(true)
      }
    
    //MARK: - setupUI
    private func configureUI() {
        
        self.backgroundColor = .white
        
        [ titleLabel,
          emaiTextField,
          passwordTextField,
          passwordCheckTextField,
          nicknameTextField,
          birthdayTextField,
          genderSegment,
          incomePicker,
          locationPicker,
          signupButton
        ].forEach {
            verticalStackView.addArrangedSubview($0)
        }
        
        [verticalStackView].forEach { self.addSubview($0)}
    }
    
    private func setupLayout() {
        verticalStackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(18)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.height.equalTo(576)
        }
    }
    
}


