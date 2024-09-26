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
    private let selectionView = FinancialPlanSelectionView()
    private let planService: FinancialPlanService = FinancialPlanService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectionView.collectionView.dataSource = self
        selectionView.collectionView.delegate = self
    }
    
    override func loadView() {
        view = selectionView
        view.backgroundColor = UIColor(hex: "#e9f3fd")
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
        
        if planService.fetchIncompletedPlans().count >= 10 {
            showExistingPlanAlert()
        } else {
            let createPlanVC = FinancialPlanCreationVC(planService: planService)
            createPlanVC.configure(with: planTitle, planType: selectedPlanType)
            navigationController?.pushViewController(createPlanVC, animated: true)
        }
    }
    
    private func showExistingPlanAlert() {
        let alert = UIAlertController(title: "알림", message: "동시에 진행 가능한 플랜은 10개입니다. 플랜을 삭제하거나 완료해주세요", preferredStyle: .alert)
        
        let goToCurrentPlanAction = UIAlertAction(title: "현재 플랜 보기", style: .default) { [weak self] _ in
            self?.navigateToCurrentPlanVC()
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(goToCurrentPlanAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func navigateToCurrentPlanVC() {
        let currentPlanVC = FinancialPlanCurrentPlanVC(planService: planService)
        navigationController?.pushViewController(currentPlanVC, animated: true)
    }
}
