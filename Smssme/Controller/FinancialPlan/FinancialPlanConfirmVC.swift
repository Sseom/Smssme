//
//  FinancialPlanConfirmVC.swift
//  Smssme
//
//  Created by 임혜정 on 8/28/24.
//

import UIKit

class FinancialPlanConfirmVC: UIViewController {
    private let financialPlanConfirmView: FinancialPlanConfirmView
    
    init(financialPlanConfirmView: FinancialPlanConfirmView) {
        self.financialPlanConfirmView = financialPlanConfirmView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        print("플랜확인창으로 이동되었습니다")
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
        print("버튼탭드버튼눌림")
        let financialPlanCurrentPlanVC = FinancialPlanCurrentPlanVC(financialPlanCurrentView: FinancialPlanCurrentPlanView())
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
