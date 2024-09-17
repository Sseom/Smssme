//
//  LoginVC.swift
//  Smssme
//
//  Created by ahnzihyeon on 8/27/24.
//

import KakaoSDKAuth
import KakaoSDKUser
import FirebaseAuth
import UIKit


class LoginVC: UIViewController {
    var handle: AuthStateDidChangeListenerHandle?
    var toastMessage: String?
    
    private let loginVeiw = LoginView()
    private let planService = FinancialPlanService()
    
    override func loadView() {
        view = loginVeiw
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#3756f4")
        
        loginVeiw.emailTextField.delegate = self
        loginVeiw.passwordTextField.delegate = self
        
        setupAddtarget()
    }
    
    //    override func viewDidAppear(_ animated: Bool) {
    //        super.viewDidAppear(animated)
    //
    //        if let message = toastMessage {
    //            Toast.show(message: message, in: self)
    //        }
    //    }
    
    ///인증상태 수신 대기 - 리스터 연결
    ///각각의 앱 뷰에서 앱에 로그인한 사용자에 대한 정보를 얻기 위해 FIRAuth 객체와 리스너를 연결합니다.
    ///이 리스너는 사용자의 로그인 상태가 변경될 때마다 호출됩니다.
    override func viewWillAppear(_ animated: Bool) {
        // [START auth_listener]
        handle = Auth.auth().addStateDidChangeListener { auth, user in
        }
    }
    
    ///인증상태 수신 대기 - 리스터 분리
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    private func setupAddtarget() {
        // 로그인 버튼 클릭 시
        loginVeiw.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        // 카카오 로그인 버튼 클릭 시
//        loginVeiw.kakaoLoginButton.addTarget(self, action: #selector(kakaoLoginButtonTapped), for: .touchUpInside)
        
        // 회원가입 버튼 클릭 시 회원가입 뷰로 이동
        loginVeiw.signupButton.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
        
        // 비회원 로그인 시
        loginVeiw.unLoginButton.addTarget(self, action: #selector(unloginButtonTapped), for: .touchUpInside)
    }
    
    //MARK: - @objc 로그인
    ///기존 사용자 로그인
    ///기존 사용자가 자신의 이메일 주소와 비밀번호를 사용해 로그인할 수 있는 양식을 만듭니다. 사용자가 양식을 작성하면 signIn 메서드를 호출합니다.
    @objc func loginButtonTapped() {
        guard let email = loginVeiw.emailTextField.text, !email.isEmpty,
              let password = loginVeiw.passwordTextField.text, !password.isEmpty else {
            showAlert(message: "이메일과 패스워드를 입력해주세요.", AlertTitle: "입력 정보 오류", buttonClickTitle: "확인")
            return
        }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            guard let self = self else { return }
            // 에러가 나거나 유저가 없을 경우
            if let error = error as NSError? {
                
                switch AuthErrorCode(rawValue: error.code) {
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
                default:
                    self.showAlert(message: error.localizedDescription, AlertTitle: "에러 발생", buttonClickTitle: "확인")
                }
            } else {
//                showSnycAlert(message: "안녕하세요,\n 로그인되었습니다.", AlertTitle: "로그인 성공", buttonClickTitle: "확인", method: switchToTabBarController)
                self.checkUsersPlan()
            }
        }
    }
    
    //MARK: -로그인 후 플랜이 없는 경우 hj
    private func checkUsersPlan() {
        let plans = planService.fetchAllFinancialPlans()
        if plans.isEmpty {
            showSnycAlert(message: "안녕하세요, 자산 플랜을 생성해 주세요", AlertTitle: "로그인되었습니다", buttonClickTitle: "확인", method: switchToPlanSelectVC)
        } else {
            showSnycAlert(message: "안녕하세요, 로그인되었습니다", AlertTitle: "로그인되었습니다", buttonClickTitle: "확인", method: switchToTabBarController)
        }
    }
    
    func switchToPlanSelectVC() {
        let tabBarController = TabBarController()
        tabBarController.selectedIndex = 2
        print("로그인하고 페이지 전환")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {return}
        
        window.rootViewController = tabBarController
    }
    
    //MARK: - 로그인 하고 탭바컨트롤러로 전환
    func switchToTabBarController() {
        let tabBarController = TabBarController()
        print("로그인하고 페이지 전환")
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
        let navController = UINavigationController(rootViewController: emailVC)
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        window.rootViewController = navController
        window.makeKeyAndVisible()
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
