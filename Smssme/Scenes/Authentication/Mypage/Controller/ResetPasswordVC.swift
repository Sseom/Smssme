//
//  ResetPasswordVC.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/17/24.
//

import FirebaseAuth
import UIKit

class ResetPasswordVC: UIViewController {
    private let resetPasswordView = ResetPasswordView()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = resetPasswordView
        self.navigationItem.title = "비밀번호 재설정"
        navigationController?.isNavigationBarHidden = false
        
        resetPasswordView.editEmailTextVeiw.delegate = self
        
        let currentUserEmail = Auth.auth().currentUser?.email ?? "이메일을 입력해주세요."
        resetPasswordView.emailTextField.placeholder = currentUserEmail
        
        setAddTarget()
    }
    
    
    //MARK: - Methods
    func showPasswordVerificationButton() {
        DispatchQueue.main.async {
            self.resetPasswordView.sendResetPasswordButton.isHidden = false
        }
    }
    
    private func setAddTarget() {
        resetPasswordView.checkEmailButton.addTarget(self, action: #selector(validationEmailButtonTapped), for: .touchUpInside)
        resetPasswordView.sendResetPasswordButton.addTarget(self, action: #selector(sendPasswordResetButtonTapped), for: .touchUpInside)
    }
    
    // '인증하기' 버튼 클릭 - 이메일 인증 메일 발송 버튼
    @objc private func validationEmailButtonTapped() {
        // 이메일 형식 유효성 검사
        guard let email = resetPasswordView.emailTextField.text else { return}
        
        if isValidEmail(email: email) {
            
            FirebaseManager.shared.checkEmail(email: email) { exists in
                if exists {
                    self.showSnycAlert(message: "가입된 이메일 계정입니다.", AlertTitle: "사용자 계정 인증 완료", buttonClickTitle: "확인") {
                        self.resetPasswordView.sendResetPasswordButton.isEnabled = true
                        self.resetPasswordView.sendResetPasswordButton.backgroundColor = .systemBlue
                    }
                } else {
                    //저장되지 않은 이메일
                    self.showAlert(message: "존재하지 않는 이메일 계정입니다.", AlertTitle: "경고", buttonClickTitle: "확인")
                }
            }
        } else {
            showAlert(message: "유효하지 않은 이메일 형식입니다.", AlertTitle: "오류", buttonClickTitle: "확인")
        }
        
        // 이메일 형식 검증을 위한 정규 표현식
        func isValidEmail(email: String) -> Bool {
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            return emailPred.evaluate(with: email)
        }
        
    }
    
    // 비밀번호 재설정 메일 발송
    @objc private func sendPasswordResetButtonTapped() {
        guard let email = resetPasswordView.emailTextField.text, !email.isEmpty else {
            showAlert(message: "이메일을 입력해주세요.", AlertTitle: "경고", buttonClickTitle: "확인")
            return
        }
        
        FirebaseManager.shared.sendPasswordResetEmail(email: email) { error in
            if let error = error {
                self.showAlert(message: "비밀번호 재설정 메일 발송에 실패했습니다.", AlertTitle: "오류", buttonClickTitle: "확인")
            } else {
                self.showSnycAlert(message: "비밀번호 재설정 메일이 발송되었습니다.\n메일을 확인해주세요.", AlertTitle: "메일 발송 완료", buttonClickTitle: "확인") {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
}

//MARK: - TextView extension
extension ResetPasswordVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let editEmailRange = NSString(string: textView.text).range(of: "계정 이메일 재설정")
        
        // "계정 이메일 재설정"이 클릭된 경우
        if NSEqualRanges(characterRange, editEmailRange) { // 두 NSRange의 시작 위치와 길이가 같은지 비교
//                        let emailVC = EmailVC()
//                        emailVC.navigationItem.title = "이메일 재설정"
//                        navigationController?.pushViewController(emailVC, animated: true)
            showSnycAlert(message: "준비 중인 페이지입니다.\n새로 회원가입해주세요.", AlertTitle: "알림", buttonClickTitle: "확인") {
                self.navigationController?.popViewController(animated: true)
            }
            return false
        }
        return true
    }
}
