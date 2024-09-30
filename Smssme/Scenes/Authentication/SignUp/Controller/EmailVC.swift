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
    var userData = UserData()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = emailView
        
        emailView.emailTextField.delegate = self
        setAddtarget()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
        if navigationItem.title == "이메일 재설정" {
            emailView.progressBar.isHidden = true
            emailView.passwordTextField.isHidden = false
            
            emailView.checkEmailButton.setTitle("변경", for: .normal)
            emailView.nextButton.setTitle("이메일 재설정", for: .normal)
            // '이메일 재설정' 버튼을 눌렀을 때의 로직
            emailView.nextButton.removeTarget(self, action: nil, for: .allEvents) //기존의 모든 액션 제거
            emailView.nextButton.addTarget(self, action: #selector(onEmailChangeButtonTapped), for: .touchUpInside)
        } else {
            emailView.nextButton.setTitle("다음", for: .normal)
            // '다음' 버튼을 눌렀을 때의 로직 (회원가입 진행)
            emailView.nextButton.removeTarget(self, action: nil, for: .allEvents)
            emailView.nextButton.addTarget(self, action: #selector(onNextButtonTapped), for: .touchUpInside)
        }
        
    }
    
    private func setAddtarget() {
        emailView.emailTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        emailView.checkEmailButton.addTarget(self, action: #selector(checkEmailButtonTapped), for: .touchUpInside)
        //        emailView.nextButton.addTarget(self, action: #selector(onNextButtonTapped), for: .touchUpInside)
    }
    
    //MARK: - '다음' 버튼 이벤트
    @objc private func onNextButtonTapped() {
        userData.email = emailView.emailTextField.text
        
        let passwordVC = PasswordVC()
        passwordVC.userData = userData //데이터 전달
        navigationController?.pushViewController(passwordVC, animated: true)
    }
    
    //MARK: - '이메일 변경' 버튼 이벤트
    @objc private func onEmailChangeButtonTapped() {
        //        userData.email = emailView.emailTextField.text
        guard let newEmail = emailView.emailTextField.text,
        let password = emailView.passwordTextField.text else { return }
        
        FirebaseAuthManager.shared.updateEmail(newEmail: newEmail, password: password) { success, error in
            if success {
                self.showSnycAlert(message: "이메일 변경에 성공했습니다.", AlertTitle: "성공", buttonClickTitle: "확인") {
                    self.navigationController?.popViewController(animated: true)
                }
            } else if let error = error {
                self.showAlert(message: "이메일 변경에 실패했습니다.", AlertTitle: "이메일 변경 실패", buttonClickTitle: "확인")
                print("이메일 변경에 실패했습니다: \(error)")
            }
        }
    }
    
    //MARK: - '중복확인' 버튼 이벤트
    @objc private func checkEmailButtonTapped() {
        
        guard let email = emailView.emailTextField.text, !email.isEmpty else {
            return
        }
        
        // 이메일 형식이 유효할 때만 중복 검사
        if isValidEmail(email: email) {
            FirebaseAuthManager.shared.checkEmail(email: email) { exists in
                if exists {
                    self.updateOnNextButton(isValidFormat: true, isEmailDuplicate: true, message: "중복된 이메일입니다.", textColor: .systemRed)
                } else {
                    self.updateOnNextButton(isValidFormat: true, isEmailDuplicate: false, message: "사용 가능한 이메일입니다.", textColor: .systemGreen)
                }
            }
        } else {
            updateOnNextButton(isValidFormat: false, isEmailDuplicate: false, message: "유효하지 않은 이메일 형식입니다.", textColor: .systemRed)
        }
        
    }
    
}

//MARK: - 유효성검사  UITextField extension
extension EmailVC {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else {return false} //NSRange 타입을 Swift의 Range<String.Index>로 변환
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        // 이메일 형식 유효성 검사
        if textField == emailView.emailTextField {
            
            if isValidEmail(email: updatedText) {
                emailView.emailErrorLabel.text = "유효한 이메일 형식입니다. 중복검사를 해주세요."
                emailView.emailErrorLabel.textColor = .systemGreen
            } else {
                emailView.emailErrorLabel.text = "유효하지 않은 이메일 형식입니다."
                emailView.emailErrorLabel.textColor = .systemRed
            }
            // 이메일 형식만 검증 후 버튼 비활성화 (중복 확인 후 활성화)
            emailView.nextButton.backgroundColor = .systemGray5
            emailView.nextButton.isEnabled = false
        }
        return true
    }
    
    // 이메일 형식 검증을 위한 정규 표현식
    private func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPred.evaluate(with: email)
    }
    
    // 이메일 형식 검사 및 중복 검사에 따른 버튼활성화
    private func updateOnNextButton(isValidFormat: Bool, isEmailDuplicate: Bool, message:String, textColor: UIColor) {
        emailView.emailErrorLabel.text = message
        emailView.emailErrorLabel.textColor = textColor
        
        if isValidFormat && !isEmailDuplicate {
            emailView.nextButton.backgroundColor = .systemBlue
            emailView.nextButton.isEnabled = true
        } else {
            emailView.nextButton.backgroundColor = .systemGray5
            emailView.nextButton.isEnabled = false
        }
    }
    
}




//MARK: - 입력 중인 텍스트필드 표시 UITextField extension
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
            emailView.emailTextField.resignFirstResponder()
        }
        return true
    }
    
    
    // 공백 입력 방지
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        textField.text = textField.text?.trimmingCharacters(in: .whitespaces)
    }
    
}
