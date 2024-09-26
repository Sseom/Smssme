//
//  SplashViewController.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/2/24.
//

import UIKit
import FirebaseAuth


class SplashViewController: UIViewController {
    var authHandle: AuthStateDidChangeListenerHandle?
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let splashImage = UIImageView(image: UIImage(named: "splashImage"))
        splashImage.contentMode = .scaleAspectFit
        view.addSubview(splashImage)
        
        splashImage.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(150)
        }
        
        // 0.5초 후에 로그인 상태 확인
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.addAuthListener()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeAuthListener()  // 리스너 제거
    }
    
    //MARK: - Methods
    // Firebase 인증 상태 리스너 추가
    func addAuthListener() {
        authHandle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            guard let self = self else { return }
            if let user = user {
                // 로그인된 사용자
                print("로그인된 사용자입니다. 사용자는 \(user.uid)")
                showMainVC()
            } else {
                // 로그인 되지 않은 사용자
                print("로그인되지 않은 사용자입니다.")
                showLoginVC()
            }
        }
    }
    
    // 리스너 제거
    func removeAuthListener() {
        if let handle = authHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    // 메인 화면으로 전환
    func showMainVC() {
        let mainTabBarController = TabBarController()
        // 전체화면 전환 (애니메이션 포함)
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        window.rootViewController = mainTabBarController
        UIView.transition(with: window,
                          duration: 0.3,
                          options: [.transitionCrossDissolve],
                          animations: nil,
                          completion: nil)
    }
    
    // 로그인 화면으로 전환
    func showLoginVC() {
        let loginVC = LoginVC()
        let navController = UINavigationController(rootViewController: loginVC)
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        window.rootViewController = navController
        UIView.transition(with: window,
                          duration: 0.3,
                          options: [.transitionCrossDissolve],
                          animations: nil,
                          completion: nil)
    }
    
    
}
