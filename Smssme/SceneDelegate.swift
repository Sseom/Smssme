//
//  SceneDelegate.swift
//  Smssme
//
//  Created by 전성진 on 8/22/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = SplashViewController()
        window.makeKeyAndVisible()
        
        self.window = window
        
        
        
        //MARK: - 혜정 / ui작업 확인용 코드 , 완료 시 삭제
//        window = UIWindow(windowScene: windowScene)
//        
//        let financialPlanSelectionView = FinancialPlanSelectionView()
//        let financialPlanSelectionVC = FinancialPlanSelectionVC(financialPlanSelectionView: financialPlanSelectionView)
//        
//        let navigationController = UINavigationController(rootViewController: financialPlanSelectionVC)
//        
//        window?.rootViewController = navigationController
//        window?.makeKeyAndVisible()
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {

    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

