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
        
        resetPasswordView.editEmailTextVeiw.delegate = self
        
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
    
    //MARK: - 이메일 인증 메일 발송 버튼
    @objc private func checkEmailButtonTapped() {
        FirebaseManager.shared.sendEmailVerification { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    print("이메일 인증 전송 완료")
                    
                    self.showSnycAlert(message: "이메일 인증 메일 발송 완료되었습니다.\n메일을 확인해주세요.", AlertTitle: "성공", buttonClickTitle: "확인") {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.resetPasswordView.sendResetPasswordButton.isEnabled = true
                            self.resetPasswordView.sendResetPasswordButton.backgroundColor = .systemBlue
                        }
                    }
                }
            case .failure(let error):
                // 이메일 인증 메일 전송 실패 처리
                DispatchQueue.main.async {
                    print("이메일 인증 오류: \(error.localizedDescription)")

                    self.showAlert(message: "이메일 인증 메일 발송에 실패했습니다.\n이메일 주소를 다시 확인해주세요.", AlertTitle: "오류", buttonClickTitle: "확인")
                }
            }
        }
    }
    
    //MARK: - 비밀번호 재설정 메일 발송 버튼
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                        
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
//            let emailVC = EmailVC()
//            emailVC.navigationItem.title = "이메일 재설정"
//            navigationController?.pushViewController(emailVC, animated: true)
            showAlert(message: "준비 중인 페이지입니다.", AlertTitle: "알림", buttonClickTitle: "확인")
            return false
        }
        return true
    }
}
