//
//  FinancialPlanCurrentPlanVC.swift
//  Smssme
//
//  Created by 임혜정 on 8/29/24.
//

import UIKit

final class FinancialPlanCurrentPlanVC: UIViewController {
    private let financialPlanCurrentView = FinancialPlanCurrentPlanView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupAddPlanButtonAction()
    }
    
    override func loadView() {
        view = financialPlanCurrentView
    }
    
    private func setupAddPlanButtonAction() {
            financialPlanCurrentView.onAddPlanButtonTapped = { [weak self] in
                self?.actionAddPlanButton()
            }
        }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController is FinancialPlanCurrentPlanVC {
            if let index = navigationController.viewControllers.firstIndex(of: viewController) {
                navigationController.viewControllers.removeSubrange(0..<index)
            }
        }
    }
    
}

extension FinancialPlanCurrentPlanVC {
    func actionAddPlanButton() {
        let financialPlanConfirmVC = FinancialPlanSelectionVC()
        navigationController?.pushViewController(financialPlanConfirmVC, animated: true)
    }
}
