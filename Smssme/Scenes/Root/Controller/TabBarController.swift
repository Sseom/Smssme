//
//  TabBarController.swift
//  Smssme
//
//  Created by 전성진 on 8/28/24.
//

import FirebaseAuth
import UIKit

// MARK: - 기본 제공 탭바 아이콘 위치가 너무 상단이라 커스텀
class CustomTabBar: UITabBar {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let tabBarItemHeight: CGFloat = 32.0 // 아이콘의 높이
        let bottomInset: CGFloat = 48.0 // 아이콘을 아래로 내릴 거리
        
        self.items?.forEach { item in
            item.imageInsets = UIEdgeInsets(top: (self.bounds.height - tabBarItemHeight - bottomInset), left: 0, bottom: bottomInset, right: 0)
        }
    }
}

class TabBarController: UITabBarController {
    private let customTabBar = CustomTabBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tabBar.backgroundColor = .white
        tabBar.itemPositioning = .centered
        configureController()
        showFirstView()
        self.setValue(customTabBar, forKey: "tabBar")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var tabFrame = self.tabBar.frame
        let screenHeight = UIScreen.main.bounds.height
        let tabBarHeightProportion: CGFloat
        if isIPadMini() {
          tabBarHeightProportion = 0.08 // iPad mini에 대해 8%로 설정
        } else {
          tabBarHeightProportion = 0.11 // 다른 기기들에 대해 11%로 유지
        }
        tabFrame.size.height = screenHeight * tabBarHeightProportion
        tabFrame.origin.y = self.view.frame.size.height - tabFrame.size.height
        self.tabBar.frame = tabFrame
      }
    
      private func isIPadMini() -> Bool {
        let deviceModel = UIDevice.current.model
        return deviceModel == "iPad"
      }
    
    func configureController() {
        let mainPage = tabBarNavigationController(
            unselectedImage: UIImage(systemName: "house.fill") ?? UIImage(),
            selectedImage: UIImage(systemName: "house.fill") ?? UIImage(),
            isNavigationBarHidden: true,
            rootViewController: MainPageVC()
        )
        
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
            rootViewController: planPageCondition()
        )
        
        let futureGraph = tabBarNavigationController(
            unselectedImage: UIImage(systemName: "chart.bar.xaxis") ?? UIImage(),
            selectedImage: UIImage(systemName: "chart.bar.xaxis") ?? UIImage(),
            isNavigationBarHidden: true,
            rootViewController: FutureGraphVC()
        )
        
        let myPage = tabBarNavigationController(
            unselectedImage: UIImage(systemName: "person.fill") ?? UIImage(),
            selectedImage: UIImage(systemName: "person.fill") ?? UIImage(),
            isNavigationBarHidden: false,
            rootViewController: MypageVC()
        )
        viewControllers = [mainPage, diary, financialPlan, futureGraph, myPage]
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

// MARK: - 페이지 분기 처리
extension TabBarController {
    // 로그인 유무에 따라 앱 실행 시 처음 보여줄 탭 설정
    private func showFirstView() {
        if let user  = Auth.auth().currentUser {
            self.selectedViewController = viewControllers?[0]
        } else {
            self.selectedViewController = viewControllers?[2]
        }
    }
    
    // 진행중 플랜이 있다면 막대그래프 페이지, 아니면 선택창
    private func planPageCondition() -> UIViewController {
        let planService = FinancialPlanService()
        let plans = planService.fetchIncompletedPlans()
        
        if plans.isEmpty {
            return FinancialPlanSelectionVC()
        } else {
            let firstPlan = plans.first!
            return FinancialPlanCurrentPlanVC(planService: planService, planDTO: firstPlan)
        }
    }
}
