//
//  FinancialPlanConfirmVC.swift
//  Smssme
//
//  Created by 임혜정 on 8/28/24.
//

import UIKit

class FinancialPlanConfirmVC: UIViewController {
    private let confirmView = FinancialPlanConfirmView()
    private let financialPlanManager: FinancialPlanManager
    private var financialPlan: FinancialPlan
    
    init(financialPlanManager: FinancialPlanManager, financialPlan: FinancialPlan) {
        self.financialPlanManager = financialPlanManager
        self.financialPlan = financialPlan
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configure(with: financialPlan)
    }
    
    override func loadView() {
        view = confirmView
        setupActions()
        
    }
    
    private func configure(with plan: FinancialPlan) {
        confirmView.confirmLargeTitle.text = "\(plan.title ?? "")"
        confirmView.amountGoalLabel.text = "\(plan.amount)"
        confirmView.currentSavedLabel.text = "\(plan.deposit)"
//        confirmView.endDateLabel.text = plan.endDate
//        confirmView.daysLeftLabel.text = plan.endDate - plan.startDate
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
