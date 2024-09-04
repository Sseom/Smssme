//
//  FinancialPlanConfirmVC.swift
//  Smssme
//
//  Created by 임혜정 on 8/28/24.
//

import UIKit

class FinancialPlanConfirmVC: UIViewController, FinancialPlanEditDelegate {
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
    
    func didUpdateFinacialPlan(_ plan: FinancialPlan) {
        self.financialPlan = plan
        configure(with: plan)
    }
    
    private func configure(with plan: FinancialPlan) {
        confirmView.confirmLargeTitle.text = "\(plan.title ?? "")"
        confirmView.amountGoalLabel.text = "목표금액 \(plan.amount)원"
        confirmView.currentSavedLabel.text = "달성금액 \(plan.deposit)원"
        // 종료 날짜
        if let endDate = plan.endDate {
            confirmView.endDateLabel.text = "목표날짜 \(FinancialPlanDateModel.dateFormatter.string(from: endDate))"
        }
        // 남은 일수
        if let endDate = plan.endDate {
            let calendar = Calendar.current
            let now = Date()
            let components = calendar.dateComponents([.day], from: now, to: endDate)
            if let daysLeft = components.day {
                confirmView.daysLeftLabel.text = "남은 날짜 \(daysLeft)일"
            }
        }
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
        let financialPlanEditPlanVC = FinancialPlanEditPlanVC(financialPlanManager: FinancialPlanManager.shared, textFieldArea: CreatePlanTextFieldView(), financialPlan: financialPlan)
        financialPlanEditPlanVC.delegate = self
        navigationController?.pushViewController(financialPlanEditPlanVC, animated: true)
    }
    
    private func confirmButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
