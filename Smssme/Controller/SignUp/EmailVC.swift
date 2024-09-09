//
//  LoginViewController.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/8/24.
//

import UIKit

class EmailVC: UIViewController {
    private let emailView = EmailView()
    private var textField = UITextField()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = emailView
        self.navigationItem.title = "회원가입"
        
        emailView.emailTextField.delegate = self
        emailView.passwordTextField.delegate = self
        emailView.passwordCheckTextField.delegate = self
        
        emailView.emailTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        emailView.passwordTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        emailView.passwordCheckTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        
        emailView.nextButton.addTarget(self, action: #selector(onNextButtonTapped), for: .touchUpInside)
    }
    
    
    @objc private func onNextButtonTapped() {
        let passwordVC = PasswordVC()
        navigationController?.pushViewController(passwordVC, animated: true)
    }
  
}


//MARK: - UITextField extension
extension EmailVC: UITextFieldDelegate {
    
    // 입력 시작 시
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    // 입력 끝날 시
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.systemGray5.cgColor
    }
    
    // 엔터 누르면 포커스 이동 후 키보드 내림
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField ==  emailView.emailTextField {
            emailView.passwordTextField.becomeFirstResponder()
        } else if textField == emailView.passwordTextField {
            emailView.passwordCheckTextField.becomeFirstResponder()
        } else {
            emailView.passwordCheckTextField.resignFirstResponder()
        }
        return true
    }
    

    // 모든 내용 입력돼야 버튼 활성화
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        print(#function)
        // 공백 입력 방지 -> 중간에 입력할 시에는 적용되는 문제 있음
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let email = emailView.emailTextField.text, !email.isEmpty,
            let password = emailView.passwordTextField.text, !password.isEmpty,
            let passwordCheck = emailView.passwordCheckTextField.text, !passwordCheck.isEmpty
        else {
            emailView.nextButton.backgroundColor = .systemGray5
            emailView.nextButton.isEnabled = false
            return
        }
        emailView.nextButton.backgroundColor = .systemBlue
        emailView.nextButton.isEnabled = true
    }
    
}
