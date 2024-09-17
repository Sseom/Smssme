//
//  TabBarController.swift
//  Smssme
//
//  Created by 전성진 on 8/28/24.
//

import FirebaseAuth
import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .white
        tabBar.itemPositioning = .centered
        view.backgroundColor = .white
        configureController()
        showFirstView()
    }
    
    // 로그인 유무에 따라 앱 실행 시 처음 보여줄 탭 설정
    private func showFirstView() {
        if let user  = Auth.auth().currentUser {
            self.selectedViewController = viewControllers?[0]
        } else {
            self.selectedViewController = viewControllers?[2]
        }
    }
    
    func configureController() {
        //메인페이지
        let mainPage = tabBarNavigationController(
            unselectedImage: UIImage(systemName: "house.fill") ?? UIImage(),
            selectedImage: UIImage(systemName: "house.fill") ?? UIImage(),
            isNavigationBarHidden: true,
            rootViewController: MainPageVC()
        )
        
        //머니다이어리
        let diary = tabBarNavigationController(
            unselectedImage: UIImage(systemName: "calendar") ?? UIImage(),
            selectedImage: UIImage(systemName: "calendar") ?? UIImage(),
            isNavigationBarHidden: false,
            rootViewController: MoneyDiaryVC(moneyDiaryView: MoneyDiaryView())
        )

        let financialPlan = tabBarNavigationController(
            unselectedImage: UIImage(systemName: "note.text.badge.plus") ?? UIImage(),
            selectedImage: UIImage(systemName: "note.text.badge.plus") ?? UIImage(),
            isNavigationBarHidden: false,
            rootViewController: {
                let planService = FinancialPlanService()
                let plans = planService.fetchAllFinancialPlans()
                
                if plans.isEmpty {
                    return FinancialPlanSelectionVC()
                } else {
                    let firstPlan = plans.first!
                    return FinancialPlanCurrentPlanVC(planService: planService, planDTO: firstPlan)
                }
            }()
        )
        
        // 마이페이지
        let myPage = tabBarNavigationController(
            unselectedImage: UIImage(systemName: "person.and.background.striped.horizontal") ?? UIImage(),
            selectedImage: UIImage(systemName: "person.and.background.striped.horizontal") ?? UIImage(),
            isNavigationBarHidden: false,
            rootViewController: MypageVC()
        )
        viewControllers = [mainPage, diary, financialPlan, myPage]
    }
    
    //MARK: 제네릭으로 navigationController 안쓰는 뷰면 나눠서 반환해주게끔 개선 하면 좋을거 같음
    func tabBarNavigationController(unselectedImage: UIImage, selectedImage: UIImage, isNavigationBarHidden: Bool, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.isNavigationBarHidden = isNavigationBarHidden
        nav.navigationBar.tintColor = .systemBlue
        return nav
    }
}

