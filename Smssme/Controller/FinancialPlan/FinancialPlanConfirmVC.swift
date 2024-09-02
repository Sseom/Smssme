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
}

// MARK: - 버튼 액션 관련
extension FinancialPlanConfirmVC {
    private func setupActions() {
        financialPlanConfirmView.confirmButton.addAction(UIAction(handler: { [weak self] _ in
            self?.confirmButtonTapped()
        }), for: .touchUpInside)
        financialPlanConfirmView.editButton.addAction(UIAction(handler: { [weak self] _ in
            self?.editButtonTapped()
        }), for: .touchUpInside)
    }
    
    private func editButtonTapped() {
        let financialPlanEditPlanVC = FinancialPlanEditPlanVC(textFieldArea: CreatePlanTextFieldView())
        navigationController?.pushViewController(financialPlanEditPlanVC, animated: true)
    }
    
    private func confirmButtonTapped() {
        let financialPlanCurrentPlanVC = FinancialPlanCurrentPlanVC()
        navigationController?.pushViewController(financialPlanCurrentPlanVC, animated: true)
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
