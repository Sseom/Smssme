//
//  ReauthenticationVC.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/19/24.
//

import UIKit
import FirebaseAuth

// 파이어베이스에서 이메일(아이디) 변경 및 회원탈퇴를 위한 로그인 구현입니다.
class ReauthenticationVC: UIViewController {
    let reauthenticationView = ReauthenticationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = reauthenticationView
        navigationItem.title = "재인증"
        
        reauthenticationView.emailTextField.delegate = self
        reauthenticationView.passwordTextField.delegate = self
        
        reauthenticationView.deleteUserButton.addTarget(self, action: #selector(deleteUserButtonTapped), for: .touchUpInside)
    }
    
    // 재인증 버튼 클릭 시
    @objc private func deleteUserButtonTapped() {
        guard let email = reauthenticationView.emailTextField.text, !email.isEmpty,
              let password = reauthenticationView.passwordTextField.text, !password.isEmpty else { return }
        
        FirebaseAuthManager.shared.deleteUser(email: email,password: password) { success, error in
            if success {
                print("회원탈퇴 완료")
                self.showSnycAlert(message: "회원탈퇴에 성공했습니다.", AlertTitle: "성공", buttonClickTitle: "확인") {
                    let loginVC = LoginVC()
                    self.navigationController?.pushViewController(loginVC, animated: true)
                }
            } else if let error = error {
                print("회원탈퇴 실패")
                self.showAlert(message: "회원탈퇴에 실패했습니다.\n\(error)", AlertTitle: "오류", buttonClickTitle: "확인")
                print(error)
            }
        }
    }
    
}




//MARK: - 입력 중인 텍스트필드 표시 UITextField extension
extension ReauthenticationVC: UITextFieldDelegate {
    
    // 입력 시작 시
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    // 입력 끝날 시
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.systemGray5.cgColor
        
        
        guard let email = reauthenticationView.emailTextField.text,
              let password = reauthenticationView.passwordTextField.text else {return}
        
        if !email.isEmpty && !password.isEmpty {
            reauthenticationView.deleteUserButton.backgroundColor = .systemBlue
            reauthenticationView.deleteUserButton.isEnabled = true
        } else {
            reauthenticationView.deleteUserButton.backgroundColor = .systemGray5
            reauthenticationView.deleteUserButton.isEnabled = false
        }
    }
    
    // 엔터 누르면 포커스 이동 후 키보드 내림
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField ==  reauthenticationView.emailTextField {
            reauthenticationView.passwordTextField.becomeFirstResponder()
        } else if textField == reauthenticationView.passwordTextField {
            reauthenticationView.passwordTextField.resignFirstResponder()
        }
        return true
    }
    
    
    // 공백 입력 방지
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        textField.text = textField.text?.trimmingCharacters(in: .whitespaces)
    }
    
}
