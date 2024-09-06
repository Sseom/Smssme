//
//  SplashViewController.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/2/24.
//

import UIKit
import FirebaseAuth


class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 스플래쉬 이미지 임시 사용 중
        let splashImage = UIImageView(image: UIImage(named: "splash"))
        splashImage.contentMode = .scaleAspectFit
        view.addSubview(splashImage)
        
        splashImage.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        // 0.5초 후에 로그인 상태 확인
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.checkLoginStatus()
        }
    }
    
    private func checkLoginStatus() {
        if let user  = Auth.auth().currentUser {
            print("로그인된 사용자입니다. 사용자는 \(user.uid ?? "알 수 없는 이메일입니다.")")
            showMainVC()
        } else {
            print("로그인되지 않은 사용자입니다.")
            showLoginVC()
        }
    }
    
    func showMainVC() {
        let mainTabBarController = TabBarController()
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
    
    func showLoginVC() {
        let loginVC = LoginVC()
        let navController = UINavigationController(rootViewController: loginVC)
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        window.rootViewController = navController // UINavigationController를 rootViewController로 설정
        UIView.transition(with: window,
                          duration: 0.5,
                          options: [.transitionCrossDissolve],
                          animations: nil,
                          completion: nil)
    }
    
    
}
