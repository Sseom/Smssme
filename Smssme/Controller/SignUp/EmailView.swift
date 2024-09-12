//
//  EmailView.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/8/24.
//

import UIKit

class EmailView: UIView {
    private let commonHeight = 50
    
    //상단 제목 라벨
    private var titleLabel = LargeTitleLabel().createLabel(with: "회원가입", color: UIColor.black)
    
    //MARK: - 아이디(이메일)
    let emailLabel = SmallTitleLabel().createLabel(with: "이메일 주소", color: .black)
    
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
    
    let emailErrorLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .red
        label.font = .systemFont(ofSize: 16)
        label.isHidden = false // 기본적으로 숨김 처리
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
        
        // 스크롤뷰에서 빈 화면터치 시 키보드 내려감
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.touch))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        
        self.addGestureRecognizer(recognizer)
        
        [titleLabel,
         emailLabel,
         emailTextField,
         emailErrorLabel,
         nextButton
        ].forEach {self.addSubview($0)}
    }
    
    private func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(24)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(30)
            
            emailLabel.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(30)
                $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            }
            
            emailTextField.snp.makeConstraints {
                $0.top.equalTo(emailLabel.snp.bottom).offset(10)
                $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
                $0.height.equalTo(commonHeight)
            }
            
            emailErrorLabel.snp.makeConstraints {
                $0.top.equalTo(emailTextField.snp.bottom).offset(10)
                $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(36)
            }
            

            nextButton.snp.makeConstraints {
                $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
                $0.bottom.equalTo(safeAreaLayoutGuide).inset(280)
                $0.height.equalTo(commonHeight)
            }
        }
        
    }
    //MARK: - @objc
    // 빈 화면 터치 시 키보드 내려감
    @objc func touch() {
        self.endEditing(true)
    }
    
}
