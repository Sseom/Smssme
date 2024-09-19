//
//  FinancialPlanCurrentPlanVC.swift
//  Smssme
//
//  Created by 임혜정 on 8/29/24.
//

import UIKit

final class FinancialPlanCurrentPlanVC: UIViewController, FinancialPlanCreateDelegate, FinancialPlanEditDelegate, FinancialPlanDeleteDelegate, FinancialPlanUpdateDelegate {

    private let financialPlanCurrentView = FinancialPlanCurrentPlanView()
    private var planService: FinancialPlanService
    private var planDTO: FinancialPlanDTO
    private var plans: [FinancialPlanDTO] = []
    
    init(planService: FinancialPlanService, planDTO: FinancialPlanDTO) {
        self.planService = planService
        self.planDTO = planDTO
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupAddPlanButtonAction()
        financialPlanCurrentView.currentPlanCollectionView.dataSource = self
        financialPlanCurrentView.currentPlanCollectionView.delegate = self
        loadFinancialPlans()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFinancialPlans()
    }
    
    override func loadView() {
        view = financialPlanCurrentView
    }

    func loadSpecificPlan(_ plan: FinancialPlanDTO) {
        self.plans = [plan]
        DispatchQueue.main.async {
            self.financialPlanCurrentView.currentPlanCollectionView.reloadData()
        }
    }
    
    private func loadFinancialPlans() {
        plans = planService.fetchIncompletedPlans()
        financialPlanCurrentView.currentPlanCollectionView.reloadData()
    }
    
    private func setupAddPlanButtonAction() {
        financialPlanCurrentView.onAddPlanButtonTapped = { [weak self] in
            self?.actionAddPlanButton()
        }
    }
    
    private func actionAddPlanButton() {
        let financialPlanSelectionVC = FinancialPlanSelectionVC()
        financialPlanSelectionVC.createDelegate = self
        navigationController?.pushViewController(financialPlanSelectionVC, animated: true)
    }
}

// MARK: - 컬렉션 뷰 관련
extension FinancialPlanCurrentPlanVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return plans.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FinancialPlanCurrentPlanCell.ID, for: indexPath) as? FinancialPlanCurrentPlanCell else {
            return UICollectionViewCell()
        }
        
        let item = plans[indexPath.item]
        cell.configure(item: item, planService: planService)
        return cell
    }
}

extension FinancialPlanCurrentPlanVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPlan = plans[indexPath.item]
        let confirmVC = FinancialPlanConfirmVC(planService: planService, planDTO: selectedPlan)
        confirmVC.deleteDelegate = self
        confirmVC.updateDelegate = self
        navigationController?.pushViewController(confirmVC, animated: true)
    }
}

// MARK: - FinancialPlan CUD
extension FinancialPlanCurrentPlanVC {
    func didCreateFinancialPlan(_ plan: FinancialPlanDTO) {
        plans.insert(plan, at: 0)
        DispatchQueue.main.async {
            self.financialPlanCurrentView.currentPlanCollectionView.reloadData()
        }
    }
    
    func didUpdateFinancialPlan(_ plan: FinancialPlanDTO) {
        if let index = plans.firstIndex(where: { $0.id == plan.id }) {
            plans[index] = plan
            DispatchQueue.main.async {
                self.financialPlanCurrentView.currentPlanCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
            }
        }
    }
    
    func didDeleteFinancialPlan(_ plan: FinancialPlanDTO) {
        if let index = plans.firstIndex(where: { $0.id == plan.id }) {
            plans.remove(at: index)
            DispatchQueue.main.async {
                self.financialPlanCurrentView.currentPlanCollectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
            }
        }
    }
}
