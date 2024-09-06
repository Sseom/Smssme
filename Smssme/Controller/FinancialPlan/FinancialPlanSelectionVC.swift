//
//  FinancialPlanSelectVC.swift
//  Smssme
//
//  Created by 임혜정 on 8/27/24.
//

import UIKit

protocol FinancialPlanCreateDelegate: AnyObject {
    func didCreateFinancialPlan(_ plan: FinancialPlan)
}

final class FinancialPlanSelectionVC: UIViewController {
    weak var createDelegate: FinancialPlanEditDelegate?
    private let financialPlanSelectionView = FinancialPlanSelectionView()
    private let financialPlanManager = FinancialPlanManager.shared
    private let planItemStore = PlanItemStore.shared
    private let repository = FinancialPlanRepository()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        financialPlanSelectionView.collectionView.dataSource = self
        financialPlanSelectionView.collectionView.delegate = self
    }
    
    override func loadView() {
        view = financialPlanSelectionView
        view.backgroundColor = UIColor(hex: "#e9f3fd")
    }
}

// MARK: - Collection View Data Source
extension FinancialPlanSelectionVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return planItemStore.presetPlans.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FinancialPlanCell.ID, for: indexPath) as? FinancialPlanCell else {
            return UICollectionViewCell()
        }
        
        let plan = planItemStore.presetPlans[indexPath.item]
        cell.configure(with: plan)
        cell.cellBackgroundColor(UIColor(hex: "#ffffff"))
        
        return cell
    }
}

// MARK: - Collection View Delegate
extension FinancialPlanSelectionVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPlan = planItemStore.presetPlans[indexPath.item]
        
        if repository.isPlanTitleExists(selectedPlan.title) {
            showExistingPlanAlert(for: selectedPlan.title)
        } else {
            let createPlanVC = FinancialPlanCreateVC(financialPlanManager: FinancialPlanManager.shared, textFieldArea: CreatePlanTextFieldView(), selectedPlan: selectedPlan, repository: repository)
            navigationController?.pushViewController(createPlanVC, animated: true)
        }
    }
    
    private func showExistingPlanAlert(for title: String) {
        let alert = UIAlertController(title: "알림", message: "이미 '\(title)' 플랜을 진행 중입니다.", preferredStyle: .alert)
        
        let goToCurrentPlanAction = UIAlertAction(title: "현재 플랜 보기", style: .default) { [weak self] _ in
            self?.navigateToCurrentPlanVC(with: title)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(goToCurrentPlanAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func navigateToCurrentPlanVC(with title: String) {
        guard let plan = repository.getFinancialPlanByTitle(title) else {
            print("Error: Plan not found")
            return
        }
        
        let currentPlanVC = FinancialPlanCurrentPlanVC(repository: repository)
        currentPlanVC.loadSpecificPlan(plan)
        navigationController?.pushViewController(currentPlanVC, animated: true)
    }
}
