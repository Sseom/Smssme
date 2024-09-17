//
//  PasswordVC.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/8/24.
//

import UIKit

class PasswordVC: UIViewController, UITextFieldDelegate  {
    private let passwordView = PasswordView()
    var userData = UserData()

    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = passwordView
        
        passwordView.passwordTextField.delegate = self
        passwordView.passwordCheckTextField.delegate = self
        
        passwordView.passwordTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        passwordView.passwordCheckTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        
        passwordView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
    }
    
    
    //MARK: - '다음' 버튼 이벤트
    @objc func nextButtonTapped() {
        userData.password = passwordView.passwordCheckTextField.text
        
        let nicknameVC = NickNameVC()
        nicknameVC.userData = userData //데이터 전달
        navigationController?.pushViewController(nicknameVC, animated: true)
    }
    
}

//MARK: - 유효성검사 UITextField extension
extension PasswordVC {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else {return false} //NSRange 타입을 Swift의 Range<String.Index>로 변환
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        guard updatedText.count < 20 else { return false } // 20자 글자수로 제한
        
        // 유효성 검사
        if textField == passwordView.passwordTextField  {
            if isValidPassword(password: updatedText) {
                passwordView.passwordErrorLabel.text = "사용가능한 비밀번호입니다."
                passwordView.passwordErrorLabel.textColor = .systemGreen
            } else {
                passwordView.passwordErrorLabel.text = "비밀번호는 6자리 이상 20자리 이하, \n영어 대문자 또는 소문자 + 숫자를 포함해야 합니다."
                passwordView.passwordErrorLabel.textColor = .red
            }
            
        }
        
        return true
    }
    
    // 이메일 유효성 검사
    private func isValidPassword(password: String) -> Bool {
        // 이메일 형식 검증을 위한 정규 표현식
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*[0-9]).{6,20}"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPred.evaluate(with: password)
    }
    
    
}


//MARK: - 입력 중인 텍스트필드 표시 UITextField extension
extension PasswordVC {
    
    // 입력 시작 시
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    // 입력 끝날 시
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.systemGray5.cgColor
        
        // 비밀번호 필드가 비어 있는지 확인
        guard let password = passwordView.passwordTextField.text, !password.isEmpty,
              let passwordCheck = passwordView.passwordCheckTextField.text, !passwordCheck.isEmpty else {
            passwordView.passwordCheckErrorLabel.text = ""
            return
        }
        
        // 비밀번호 일치여부 확인
        if passwordView.passwordTextField.text == passwordView.passwordCheckTextField.text {
            passwordView.passwordCheckErrorLabel.text = "비밀번호가 일치합니다."
            passwordView.passwordCheckErrorLabel.textColor = .systemGreen
        } else {
            passwordView.passwordCheckErrorLabel.text = "비밀번호가 불일치합니다."
            passwordView.passwordCheckErrorLabel.textColor = .red
        }
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
        textField.text = textField.text?.trimmingCharacters(in: .whitespaces)
        
        guard
            passwordView.passwordTextField.text == passwordView.passwordCheckTextField.text && passwordView.passwordErrorLabel.text == "사용가능한 비밀번호입니다." // 코드 수정 필요
        else {
            passwordView.nextButton.backgroundColor = .systemGray5
            passwordView.nextButton.isEnabled = false
            return
        }
        passwordView.nextButton.backgroundColor = .systemBlue
        passwordView.nextButton.isEnabled = true
    }
    
}
