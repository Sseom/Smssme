//
//  SceneDelegate.swift
//  Smssme
//
//  Created by 전성진 on 8/22/24.
//

import FirebaseAuth
//import KakaoSDKAuth
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)

        window.rootViewController = SplashViewController()
        
//        window.rootViewController = MoneyDiaryCreationVC(diaryManager: DiaryCoreDataManager(), transactionItem2: Diary())
//        window.rootViewController = TabBarController()
        
        window.makeKeyAndVisible()
        
        self.window = window
        
    }
    
    // 카카오 로그인
//    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
//        if let url = URLContexts.first?.url {
//            if (AuthApi.isKakaoTalkLoginUrl(url)) {
//                _ = AuthController.handleOpenUrl(url: url)
//            }
//        }
//    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
    }
    
    // 이메일 인증 메일 및 비밀번호 재설정 링크 클릭 후 다시 앱으로 돌아옵니다.
    func sceneWillEnterForeground(_ scene: UIScene) {
        // 현재 활성화된 씬에 대한 상태만 처리
        guard let windowScene = scene as? UIWindowScene,
                  let window = windowScene.windows.first,
                  let resetPasswordVC = window.rootViewController as? ResetPasswordVC else { return }
            
            // 현재 로그인한 사용자 확인
            if let user = Auth.auth().currentUser {
                user.reload { error in
                    if let error = error {
                        print("사용자 데이터 reloading 오류: \(error.localizedDescription)")
                        return
                    }
                    
                    // 이메일 인증 여부 확인
                    if user.isEmailVerified {
                        print("이메일 인증이 완료되었습니다.")
                        // 이메일 인증 완료 상태에서 비밀번호 재설정 버튼 표시
                        DispatchQueue.main.async {
                            resetPasswordVC.showPasswordVerificationButton()
                        }
                    } else {
                        print("이메일 인증이 되지 않았습니다.")
                    }
                    
                    // 비밀번호 재설정 확인 (Firebase Auth에서는 별도의 상태 확인이 필요)
                    // 비밀번호 재설정 요청이 완료된 경우 확인 및 처리
                    // 예를 들어, 비밀번호 재설정 상태를 UserDefaults 등에서 확인할 수 있습니다.
//                    let isPasswordResetRequestCompleted = UserDefaults.standard.bool(forKey: "passwordResetRequestCompleted")
//                    if isPasswordResetRequestCompleted {
//                        DispatchQueue.main.async {
////                            resetPasswordVC.showPasswordResetCompletedMessage()
//                        }
//                    }
                }
            }
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    
}

