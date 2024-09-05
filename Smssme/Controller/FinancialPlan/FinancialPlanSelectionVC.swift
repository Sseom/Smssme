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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        financialPlanSelectionView.collectionView.dataSource = self
        financialPlanSelectionView.collectionView.delegate = self
        loadInitialData()
    }
    
    override func loadView() {
        view = financialPlanSelectionView
        view.backgroundColor = UIColor(hex: "#e9f3fd")
    }
    
    private func loadInitialData() {
        planItemStore.loadInitialData()
        financialPlanSelectionView.collectionView.reloadData()
    }

    @objc private func addButtonTapped() {
        let newPlan = PlanItem(title: "나만의 플랜 설정", description: "나만의 자산목표를 설정하고 체계적으로 이루어 보세요", imageName: "trip", isPreset: false)
                planItemStore.addCustomPlan(newPlan)
        financialPlanSelectionView.collectionView.reloadData()
    }
}

// MARK: - 콜렉션 뷰
extension FinancialPlanSelectionVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return planItemStore.getTotalItemCount() + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FinancialPlanCell.ID, for: indexPath) as? FinancialPlanCell else {
            return UICollectionViewCell()
        }
        
        if indexPath.item < planItemStore.getPresetPlansCount() {
            if let plan = planItemStore.getPresetPlanAt(index: indexPath.item) {
                cell.configure(with: plan)
                cell.cellBackgroundColor(UIColor(hex: "#ffffff"))
            }
        } else if indexPath.item < planItemStore.getTotalItemCount() {
            if let plan = planItemStore.getCustomPlanAt(index: indexPath.item - planItemStore.getPresetPlansCount()) {
                cell.configure(with: plan)
                cell.cellBackgroundColor(UIColor(hex: "#ffffff"))
            }
        } else {//마지막 셀일 경우
                cell.configure(with: PlanItem(title: "+ 나만의 플랜 추가", description: "새로운 플랜을 추가해보세요", imageName: "plus", isPreset: false))
                cell.cellBackgroundColor(UIColor(hex: "#666666"))
            }
        return cell
    }
}

extension FinancialPlanSelectionVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == planItemStore.getTotalItemCount() {
            addButtonTapped()
        } else {
            var selectedPlan: PlanItem?
            if indexPath.item < planItemStore.getPresetPlansCount() {
                selectedPlan = planItemStore.getPresetPlanAt(index: indexPath.item)
            } else {
                selectedPlan = planItemStore.getCustomPlanAt(index: indexPath.item - planItemStore.getPresetPlansCount())
            }
            
            if let plan = selectedPlan {
                let createPlanVC = FinancialPlanCreateVC(financialPlanManager: FinancialPlanManager.shared, textFieldArea: CreatePlanTextFieldView(), selectedPlan: plan, repository: FinancialPlanRepository())
                navigationController?.pushViewController(createPlanVC, animated: true)
            }
        }
    }
}
