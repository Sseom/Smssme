//
//  FinancialPlanCurrentPlanVC.swift
//  Smssme
//
//  Created by 임혜정 on 8/29/24.
//

import UIKit

final class FinancialPlanCurrentPlanVC: UIViewController, FinancialPlanCreateDelegate, FinancialPlanEditDelegate, FinancialPlanDeleteDelegate, FinancialPlanUpdateDelegate {

    private let currentView = FinancialPlanCurrentPlanView()
    private var planService: FinancialPlanService
    private var planDTO: FinancialPlanDTO?
    private var plans: [FinancialPlanDTO] = []
    
    init(planService: FinancialPlanService, planDTO: FinancialPlanDTO? = nil) {
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
        setupButtonAction()
        currentView.currentPlanCollectionView.dataSource = self
        currentView.currentPlanCollectionView.delegate = self
        loadFinancialPlans()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFinancialPlans()
    }
    
    override func loadView() {
        view = currentView
    }

    func loadSpecificPlan(_ plan: FinancialPlanDTO) {
        self.plans = [plan]
        DispatchQueue.main.async {
            self.currentView.currentPlanCollectionView.reloadData()
        }
    }
    
    private func loadFinancialPlans() {
        plans = planService.fetchIncompletedPlans()
        currentView.currentPlanCollectionView.reloadData()
    }
}

// MARK: - 버튼 액션 관련
extension FinancialPlanCurrentPlanVC {
    private func setupButtonAction() {
        currentView.addPlanButton.addAction(UIAction(handler: { [weak self] _ in
            self?.addPlanButtonTapped()
        }), for: .touchUpInside)
        currentView.completePlanButton.addAction(UIAction(handler: { [weak self] _ in
            self?.completeButtonTapped()}), for: .touchUpInside)
    }
    
    private func addPlanButtonTapped() {
        let financialPlanSelectionVC = FinancialPlanSelectionVC()
        financialPlanSelectionVC.createDelegate = self
        navigationController?.pushViewController(financialPlanSelectionVC, animated: true)
    }
    
    private func completeButtonTapped() {
        let completeVC = FinancialPlanCompleteVC()
        navigationController?.pushViewController(completeVC, animated: true)
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
        cell.layer.borderColor = UIColor(.gray).cgColor
        cell.layer.borderWidth = 0
        cell.layer.cornerRadius = 10
        
        
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
            self.currentView.currentPlanCollectionView.reloadData()
        }
    }
    
    func didUpdateFinancialPlan(_ plan: FinancialPlanDTO) {
        if let index = plans.firstIndex(where: { $0.id == plan.id }) {
            plans[index] = plan
            DispatchQueue.main.async {
                self.currentView.currentPlanCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
            }
        }
    }
    
    func didDeleteFinancialPlan(_ plan: FinancialPlanDTO) {
        if let index = plans.firstIndex(where: { $0.id == plan.id }) {
            plans.remove(at: index)
            DispatchQueue.main.async {
                self.currentView.currentPlanCollectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
            }
        }
    }
}
