//
//  PasswordVC.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/8/24.
//

import UIKit

class PasswordVC: UIViewController {
    private let passwordView = PasswordView()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = passwordView
        
        self.navigationItem.title = "회원가입"
        
        passwordView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
          
    }
    
    
    //MARK: - @objc
    @objc func nextButtonTapped() {
        let nicknameVC = NickNameVC()
        navigationController?.pushViewController(nicknameVC, animated: true)
    }
    
    // 모든 내용 입력돼야 버튼 활성화
//    @objc private func textFieldEditingChanged(_ textField: UITextField) {
//        print(#function)
//        // 공백 입력 방지 -> 중간에 입력할 시에는 적용되는 문제 있음
//        if textField.text?.count == 1 {
//            if textField.text?.first == " " {
//                textField.text = ""
//                return
//            }
//        }
//        guard
//            let email = emailView.emailTextField.text, !email.isEmpty,
//            let password = emailView.passwordTextField.text, !password.isEmpty,
//            let passwordCheck = emailView.passwordCheckTextField.text, !passwordCheck.isEmpty
//        else {
//            emailView.nextButton.backgroundColor = .systemGray5
//            emailView.nextButton.isEnabled = false
//            return
//        }
//        emailView.nextButton.backgroundColor = .systemBlue
//        emailView.nextButton.isEnabled = true
//    }
    
}
