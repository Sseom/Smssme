//
//  FinancialPlanConfirmVC.swift
//  Smssme
//
//  Created by 임혜정 on 8/28/24.
//

import UIKit

class FinancialPlanConfirmVC: UIViewController {
    private let confirmView = FinancialPlanConfirmView()
//    private let financialPlanManager: FinancialPlanManager
//    private var financialPlan: FinancialPlan
//    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func loadView() {
        view = confirmView
        setupActions()
        
    }
    
}

// MARK: - 버튼 액션 관련
extension FinancialPlanConfirmVC {
    private func setupActions() {
        confirmView.confirmButton.addAction(UIAction(handler: { [weak self] _ in
            self?.confirmButtonTapped()
        }), for: .touchUpInside)
        confirmView.editButton.addAction(UIAction(handler: { [weak self] _ in
            self?.editButtonTapped()
        }), for: .touchUpInside)
    }
    
    private func editButtonTapped() {
        let financialPlanEditPlanVC = FinancialPlanEditPlanVC(financialPlanManager: FinancialPlanManager.shared, textFieldArea: CreatePlanTextFieldView())
        navigationController?.pushViewController(financialPlanEditPlanVC, animated: true)
    }
    
    private func confirmButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// 이전 올라온 화면들 제거
func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
    if viewController is FinancialPlanConfirmVC {
        if let index = navigationController.viewControllers.firstIndex(of: viewController) {
            navigationController.viewControllers.removeSubrange(0..<index)
        }
    }
}
