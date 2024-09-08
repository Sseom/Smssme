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
    
    //아이디(이메일)
    let emailLabel = SmallTitleLabel().createLabel(with: "이메일", color: .black)
    
    let emaiTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "아이디(이메일 주소)를 입력해주세요."
        textField.textColor = UIColor.lightGray
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5
        textField.keyboardType = UIKeyboardType.emailAddress
        textField.clearButtonMode = .always
        return textField
    }()
    
    //비밀번호
    let passwordLabel = SmallTitleLabel().createLabel(with: "비밀번호", color: .black)
    
    var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호를 입력해주세요,"
        textField.textColor = UIColor.lightGray
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5
        textField.clearButtonMode = .always
        textField.textContentType = .oneTimeCode
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
        textField.clearButtonMode = .always
        textField.isSecureTextEntry = true
        textField.textContentType = .oneTimeCode
        return textField
    }()
    
    //다음 버튼
    var nextButton = BaseButton().createButton(text: "다음", color: UIColor.systemBlue, textColor: UIColor.white)
    
    
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
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.touch))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        
        [titleLabel,
         emailLabel,
         emaiTextField,
         passwordLabel,
         passwordTextField,
         passwordCheckTextField].forEach {self.addSubview($0)}
    }
    
    //MARK: - @objc
    @objc func touch() {
        self.endEditing(true)
    }
    
}
