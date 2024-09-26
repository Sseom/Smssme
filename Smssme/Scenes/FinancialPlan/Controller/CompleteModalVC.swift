//
//  CompleteModalVC.swift
//  Smssme
//
//  Created by 임혜정 on 9/26/24.
//

import UIKit

final class CompleteModalVC: UIViewController {
    private let modalView = CompleteModalView()
    
    private var planDTO: FinancialPlanDTO

    init(planDTO: FinancialPlanDTO) {
        self.planDTO = planDTO
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configure(with: planDTO)
        setupButtonTapped()
    }
    
    override func loadView() {
        view = modalView
    }
    
    private func configure(with plan: FinancialPlanDTO) {
        modalView.confirmLargeTitle.text = "\(plan.title)"
        modalView.confirmImage.image = UIImage(named: planDTO.planType.iconName)
        modalView.amountGoalLabel.text = "\(plan.amount.formattedAsCurrency)원"
        modalView.currentSavedLabel.text = "\(plan.deposit.formattedAsCurrency)원"
        modalView.startLabel.text = PlanDateModel.dateFormatter.string(from: plan.startDate)
        modalView.completeLabel.text = PlanDateModel.dateFormatter.string(from: plan.completionDate)
    }
    
    private func setupButtonTapped() {
        modalView.confirmButton.addAction(UIAction(handler: { [weak self] _ in
            self?.dismissModal()
        }), for: .touchUpInside)
    }
    
    private func dismissModal() {
        dismiss(animated: true, completion: nil)
    }
}

