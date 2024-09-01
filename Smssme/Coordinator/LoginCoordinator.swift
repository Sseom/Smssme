//
//  LoginCoordinator.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/1/24.
//

import UIKit

class LoginCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(childCoordinators: [Coordinator], navigationController: UINavigationController) {
        self.childCoordinators = childCoordinators
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = LoginVC()
        self.navigationController.viewControllers = [viewController]
    }
    
    
}
