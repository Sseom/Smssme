//
//  FinancialPlanSelectVC.swift
//  Smssme
//
//  Created by 임혜정 on 8/27/24.
//

import CoreData
import UIKit

protocol FinancialPlanCreateDelegate: AnyObject {
    func didCreateFinancialPlan(_ plan: FinancialPlanDTO)
}

final class FinancialPlanSelectionVC: UIViewController {
    weak var createDelegate: FinancialPlanEditDelegate?
    private let financialPlanSelectionView = FinancialPlanSelectionView()
    private let planService: FinancialPlanService = FinancialPlanService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        financialPlanSelectionView.collectionView.dataSource = self
        financialPlanSelectionView.collectionView.delegate = self
        navigateViewController()
    }
    
    override func loadView() {
        view = financialPlanSelectionView
        view.backgroundColor = UIColor(hex: "#e9f3fd")
    }
    
    private func navigateViewController() {
        let plans = planService.fetchAllFinancialPlans()
        
        if plans.isEmpty {
            // 진행 중인 플랜이 없다면 현재 뷰
        } else {
            // 진행 중인 플랜이 있다면 첫 번째 플랜을 사용하여 FinancialPlanCurrentPlanVC로 전환
            let firstPlan = plans.first!
            let currentPlanVC = FinancialPlanCurrentPlanVC(planService: planService, planDTO: firstPlan)
            
            // 현재 뷰 컨트롤러를 FinancialPlanCurrentPlanVC로 교체
            navigationController?.setViewControllers([currentPlanVC], animated: true)
        }
    }
}

// MARK: - Collection View Data Source
extension FinancialPlanSelectionVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PlanType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FinancialPlanCell.ID, for: indexPath) as? FinancialPlanCell else {
            return UICollectionViewCell()
        }
        
        let planType = PlanType.allCases[indexPath.item]
        cell.configure(with: planType)
        cell.cellBackgroundColor(UIColor(hex: "#ffffff"))
        
        return cell
    }
}

// MARK: - Collection View Delegate
extension FinancialPlanSelectionVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPlanType = PlanType.allCases[indexPath.item]
        let planTitle = selectedPlanType.title
        
        if planService.isPlanTypeExists(selectedPlanType) {
            showExistingPlanAlert(for: planTitle)
        } else {
            let createPlanVC = FinancialPlanCreateVC(planService: planService)
            createPlanVC.configure(with: planTitle, planType: selectedPlanType)
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
        guard let plan = planService.getFinancialPlanByTitle(title) else {
            print("Error: Plan not found")
            return
        }
        
        let planDTO = FinancialPlanDTO(
            id: plan.id,
            title: plan.title,
            amount: plan.amount,
            deposit: plan.deposit,
            startDate: plan.startDate,
            endDate: plan.endDate,
            planType: plan.planType
        )
        let currentPlanVC = FinancialPlanCurrentPlanVC(planService: planService, planDTO: planDTO)
        navigationController?.pushViewController(currentPlanVC, animated: true)
    }
    
    
}
