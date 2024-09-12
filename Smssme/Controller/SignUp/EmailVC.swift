//
//  LoginViewController.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/8/24.
//

import UIKit

class EmailVC: UIViewController, UITextFieldDelegate {
    private let emailView = EmailView()
    private var textField = UITextField()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = emailView
        self.navigationItem.title = "회원가입(1/4)"
        
        emailView.emailTextField.delegate = self
        
        emailView.emailTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        
        emailView.nextButton.addTarget(self, action: #selector(onNextButtonTapped), for: .touchUpInside)
    }
    
    
    @objc private func onNextButtonTapped() {
        print(#function)
        let passwordVC = PasswordVC()
        navigationController?.pushViewController(passwordVC, animated: true)
    }
    
}



//MARK: - 유효성검사  UITextField extension
extension EmailVC {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else {return false} //NSRange 타입을 Swift의 Range<String.Index>로 변환
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        // 유효성 검사
        if textField == emailView.emailTextField {
            
            if isValidEmail(email: updatedText) {
                emailView.emailErrorLabel.text = ""
                emailView.nextButton.backgroundColor = .systemBlue
                emailView.nextButton.isEnabled = true
            } else {
                emailView.emailErrorLabel.text = "유효하지 않은 이메일 주소입니다."
                emailView.nextButton.backgroundColor = .systemGray5
                emailView.nextButton.isEnabled = false
                
            }
        }
        return true
    }
    
    // 이메일 유효성 검사
    private func isValidEmail(email: String) -> Bool {
        // 이메일 형식 검증을 위한 정규 표현식
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPred.evaluate(with: email)
    }
    
}



//MARK: - 입력 중인 텍스트필드 표시 UITextField extension
extension EmailVC {
    
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
            emailView.emailTextField.resignFirstResponder()
        }
        return true
    }
    
    
    // // 공백 입력 방지 -> 중간에 입력할 시에는 적용되는 문제 있음
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        textField.text = textField.text?.trimmingCharacters(in: .whitespaces)
    }
    
}
