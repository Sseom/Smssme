//
//  LoginVC.swift
//  Smssme
//
//  Created by ahnzihyeon on 8/27/24.
//

import FirebaseAuth
import UIKit
import AuthenticationServices


class LoginVC: UIViewController {
    var toastMessage: String?
    
    private let loginVeiw = LoginView()
    private let planService = FinancialPlanService()
    private var currentNonce: String?
    
    //MARK: - Life Cycle
    override func loadView() {
        view = loginVeiw
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primaryBlue
        
        loginVeiw.emailTextField.delegate = self
        loginVeiw.passwordTextField.delegate = self
        
        setupAddtarget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    //MARK: - Methods
    private func setupAddtarget() {
        // 로그인 버튼
        loginVeiw.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        // 카카오 로그인 버튼
        //        loginVeiw.kakaoLoginButton.addTarget(self, action: #selector(kakaoLoginButtonTapped), for: .touchUpInside)
        
        // 애플 로그인 버튼
        loginVeiw.appleLoginButton.addTarget(self, action: #selector(appleLoginButtonTapped), for: .touchUpInside)
        
        // 회원가입 버튼 클릭 시 회원가입 뷰로 이동
        loginVeiw.signupButton.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
        
        // 비회원 로그인
        loginVeiw.unLoginButton.addTarget(self, action: #selector(unloginButtonTapped), for: .touchUpInside)
        
        // 비밀번호 재설정
        loginVeiw.resetPasswordButton.addTarget(self, action: #selector(resetPasswordTapped), for: .touchUpInside)
    }
    
    //MARK: - @objc 로그인
    //기존 사용자 이메일 로그인
    @objc func loginButtonTapped() {
        
        guard let email = loginVeiw.emailTextField.text, !email.isEmpty,
              let password = loginVeiw.passwordTextField.text, !password.isEmpty else {
            showAlert(message: "이메일과 패스워드를 입력해주세요.", AlertTitle: "입력 정보 오류", buttonClickTitle: "확인")
            return
        }
        
        FirebaseAuthManager.shared.login(withEmail: email, password: password) { result in
            switch result {
            case .success():
                self.checkUsersPlan()
            case .failure(let error):
                handleLoginError(error)
            }
        }
        
        func handleLoginError(_ error: AuthErrorCode) {
            switch error {
            case .userNotFound:
                self.showAlert(message: "등록되지 않은 이메일 계정입니다. \n회원가입 후 이용해주세요.", AlertTitle: "존재하지 않는 계정", buttonClickTitle: "확인")
            case .wrongPassword:
                self.showAlert(message: "잘못된 비밀번호입니다.", AlertTitle: "비밀번호 오류", buttonClickTitle: "확인")
            case .invalidEmail:
                self.showAlert(message: "올바르지 않은 이메일 형식입니다.", AlertTitle: "이메일 형식 오류", buttonClickTitle: "확인")
            case .expiredActionCode:
                self.showAlert(message: "인증 코드가 만료되었습니다. 새 인증 코드를 요청하세요." , AlertTitle: "경고", buttonClickTitle: "확인")
                
            case .invalidCredential:
                self.showAlert(message: "사용자 인증 정보가 유효하지 않습니다.", AlertTitle: "경고", buttonClickTitle: "확인")
            case .tooManyRequests:
                self.showAlert(message: "여러 번의 잘못된 로그인 시도로 \n일시적으로 계정이 비활성화됐습니다.\n 비밀번호를 재설정해주세요.", AlertTitle: "경고", buttonClickTitle: "확인")
            default:
                self.showAlert(message: error.localizedDescription, AlertTitle: "에러 발생", buttonClickTitle: "확인")
            }
            
        }
    }
    
    // apple 로그인
    @objc func appleLoginButtonTapped() {
        let nonce = FirebaseAuthManager.shared.randomNonceString()
        currentNonce = nonce
        let hashedNonce = FirebaseAuthManager.shared.sha256(nonce)  // 해시된 nonce 생성
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = hashedNonce
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    //MARK: -로그인 후 플랜이 없는 경우 hj
    private func checkUsersPlan() {
        let plans = planService.fetchIncompletedPlans()
        if plans.isEmpty {
            showSyncAlert(message: "안녕하세요, 자산 플랜을 생성해 주세요", AlertTitle: "로그인되었습니다", buttonClickTitle: "확인", method: switchToPlanSelectVC)
        } else {
            showSyncAlert(message: "안녕하세요, 로그인되었습니다", AlertTitle: "로그인되었습니다", buttonClickTitle: "확인", method: switchToTabBarController)
        }
    }
    
    func switchToPlanSelectVC() {
        let tabBarController = TabBarController()
        tabBarController.selectedIndex = 2
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {return}
        
        window.rootViewController = tabBarController
    }
    
    //MARK: - 로그인 하고 탭바컨트롤러로 전환
    func switchToTabBarController() {
        let tabBarController = TabBarController()
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {return}
        
        window.rootViewController = tabBarController
        UIView.transition(with: window,
                          duration: 0.5,
                          options: [.transitionCrossDissolve],
                          animations: nil,
                          completion: nil)
    }
    
    
    //MARK: - @objc 회원가입
    @objc private func signupButtonTapped() {
        let emailVC = EmailVC()
        emailVC.navigationItem.title = "회원가입"
        self.navigationController?.pushViewController(emailVC, animated: true)
    }
    
    //MARK: - @objc 비밀번호 재설정
    @objc private func resetPasswordTapped() {
        let resetPasswordVC = ResetPasswordVC()
        navigationController?.pushViewController(resetPasswordVC, animated: true)
    }
    
    //MARK: - @objc 비회원 로그인
    @objc private func unloginButtonTapped() {
        let mainTabBarController = TabBarController()
        mainTabBarController.selectedIndex = 0
        // 전체화면 전환 (애니메이션 포함)
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        window.rootViewController = mainTabBarController
        UIView.transition(with: window,
                          duration: 0.5,
                          options: [.transitionCrossDissolve],
                          animations: nil,
                          completion: nil)
    }
}


extension LoginVC: UITextFieldDelegate {
    // 엔터 누르면 포커스 이동 후 키보드 내림
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField ==  loginVeiw.emailTextField {
            loginVeiw.passwordTextField.becomeFirstResponder()
        } else if textField ==  loginVeiw.passwordTextField {
            loginVeiw.passwordTextField.resignFirstResponder()
        }
        return true
    }
}


extension LoginVC: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }

            let credential = OAuthProvider.appleCredential(withIDToken: idTokenString, rawNonce: nonce, fullName: appleIDCredential.fullName)
            
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Error Apple sign in: \(error.localizedDescription)")
                    return
                }
                // 로그인에 성공했을 시 실행할 메서드 추가
                self.checkUsersPlan()
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple SignIn Failed: \(error.localizedDescription)")
    }
}

extension LoginVC: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window! // 현재 ViewController의 창을 반환
    }
}
