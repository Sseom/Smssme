//
//  FinancialPlanCurrentPlanVC.swift
//  Smssme
//
//  Created by 임혜정 on 8/29/24.
//

import UIKit

final class FinancialPlanCurrentPlanVC: UIViewController, UICollectionViewDelegate {
    private let financialPlanCurrentView = FinancialPlanCurrentPlanView()
    private var currentItems: [CurrentItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupAddPlanButtonAction()
        financialPlanCurrentView.currentPlanCollectionView.dataSource = self
        financialPlanCurrentView.currentPlanCollectionView.delegate = self
        fetchItems()
    }
    
    
    override func loadView() {
        view = financialPlanCurrentView
    }
    
    private func setupAddPlanButtonAction() {
        financialPlanCurrentView.onAddPlanButtonTapped = { [weak self] in
            self?.actionAddPlanButton()
        }
    }
    
    // 진행중 그래프 관련, 임시모델
    struct CurrentItem {
        let title: String
        let completionRate: String
        let graphValue: Double
    }
    
    private func fetchItems() {
        currentItems = [
            CurrentItem(title: "planName", completionRate: "76%", graphValue: 0.5),
            CurrentItem(title: "PlanItem2", completionRate: "76%", graphValue: 0.5),
            CurrentItem(title: "PlanItem3", completionRate: "76%", graphValue: 0.5),
            CurrentItem(title: "PlanItem4", completionRate: "76%", graphValue: 0.5),
        ]
        financialPlanCurrentView.currentPlanCollectionView.reloadData()
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController is FinancialPlanCurrentPlanVC {
            if let index = navigationController.viewControllers.firstIndex(of: viewController) {
                navigationController.viewControllers.removeSubrange(0..<index)
            }
        }
    }
    
}


extension FinancialPlanCurrentPlanVC {
    func actionAddPlanButton() {
        let financialPlanConfirmVC = FinancialPlanSelectionVC()
        navigationController?.pushViewController(financialPlanConfirmVC, animated: true)
    }
}

extension FinancialPlanCurrentPlanVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FinancialPlanCurrentPlanCell.ID, for: indexPath) as? FinancialPlanCurrentPlanCell else {
            return UICollectionViewCell()
        }
        
        let item = currentItems[indexPath.item]
        cell.configure(item: item)
        return cell
    }
}
