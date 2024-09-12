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
        
        passwordView.passwordTextField.delegate = self
        passwordView.passwordCheckTextField.delegate = self
        
        passwordView.passwordTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        passwordView.passwordCheckTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        
        passwordView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
          
    }
    
    
    //MARK: - @objc
    @objc func nextButtonTapped() {
        let nicknameVC = NickNameVC()
        navigationController?.pushViewController(nicknameVC, animated: true)
    }
    
}


//MARK: - UITextField extension
extension PasswordVC: UITextFieldDelegate {
    
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
        if textField == passwordView.passwordTextField {
            passwordView.passwordCheckTextField.becomeFirstResponder()
        } else if textField == passwordView.passwordCheckTextField {
            passwordView.passwordCheckTextField.resignFirstResponder()
        }
        return true
    }
    

    // 모든 내용 입력돼야 버튼 활성화
    @objc private func textFieldEditingChanged(_ textField: UITextField) {

        // 공백 입력 방지 -> 중간에 입력할 시에는 적용되는 문제 있음
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let password = passwordView.passwordTextField.text, !password.isEmpty,
            let passwordCheck = passwordView.passwordCheckTextField.text, !passwordCheck.isEmpty
        else {
            passwordView.nextButton.backgroundColor = .systemGray5
            passwordView.nextButton.isEnabled = false
            return
        }
        passwordView.nextButton.backgroundColor = .systemBlue
        passwordView.nextButton.isEnabled = true
    }
    
}
