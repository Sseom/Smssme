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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = resetPasswordView
        self.navigationItem.title = "비밀번호 재설정"
        
        let currentUserEmail = Auth.auth().currentUser?.email ?? "이메일을 입력해주세요."
        
        resetPasswordView.emailTextField.text = currentUserEmail
        
        resetPasswordView.checkEmailButton.addTarget(self, action: #selector(checkEmailButtonTapped), for: .touchUpInside)
        resetPasswordView.sendResetPasswordButton.addTarget(self, action: #selector(sendPasswordResetButtonTapped), for: .touchUpInside)
    }
    
    func showPasswordVerificationButton() {
        DispatchQueue.main.async {
            self.resetPasswordView.sendResetPasswordButton.isHidden = false
        }
    }
    
    @objc private func checkEmailButtonTapped() {
        FirebaseManager.shared.sendEmailVerification { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    print("이메일 인증 전송 완료")
                    // 예: 사용자에게 성공 알림을 표시하거나, 다음 화면으로 이동
                    self.showAlert(message: "이메일 인증 메일 발송 완료되었습니다.\n메일을 확인해주세요.", AlertTitle: "성공", buttonClickTitle: "확인")
                }
            case .failure(let error):
                // 이메일 인증 메일 전송 실패 처리
                DispatchQueue.main.async {
                    print("이메일 인증 오류: \(error.localizedDescription)")
                    // 예: 사용자에게 실패 알림을 표시
                    self.showAlert(message: "이메일 인증 메일 발송에 실패했습니다.\n이메일 주소를 다시 확인해주세요.", AlertTitle: "오류", buttonClickTitle: "확인")
                }
            }
        }
    }
    
    @objc private func sendPasswordResetButtonTapped() {
        guard let email = resetPasswordView.emailTextField.text, !email.isEmpty else {
            showAlert(message: "이메일을 입력해주세요.", AlertTitle: "경고", buttonClickTitle: "확인")
            return
        }
        FirebaseManager.shared.sendPasswordResetEmail(email: email) { error in
            if let error = error {
                self.showAlert(message: "비밀번호 재설정 메일 발송에 실패했습니다.", AlertTitle: "오류", buttonClickTitle: "확인")
            } else {
                self.showAlert(message: "비밀번호 재설정 메일이 발송되었습니다.\n메일을 확인해주세요.", AlertTitle: "메일 발송 완료", buttonClickTitle: "확인")
            }
        }
    }
}
