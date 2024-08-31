//
//  FinancialPlanConfirmVC.swift
//  Smssme
//
//  Created by 임혜정 on 8/28/24.
//

import UIKit

class FinancialPlanConfirmVC: UIViewController {
    private let financialPlanConfirmView = FinancialPlanConfirmView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func loadView() {
        view = financialPlanConfirmView
        setupActions()
    }
    
    private func setupActions() {
        financialPlanConfirmView.confirmButton.addAction(UIAction(handler: { [weak self] _ in
            self?.buttonTapped()
        }), for: .touchUpInside)
    }
    
    func buttonTapped() {
        let financialPlanCurrentPlanVC = FinancialPlanCurrentPlanVC()
        navigationController?.pushViewController(financialPlanCurrentPlanVC, animated: true)
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController is FinancialPlanConfirmVC {
            if let index = navigationController.viewControllers.firstIndex(of: viewController) {
                navigationController.viewControllers.removeSubrange(0..<index)
            }
        }
    }
}
