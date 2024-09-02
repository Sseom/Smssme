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
            CurrentItem(title: "PlanName", completionRate: "76%", graphValue: 0.5),
            CurrentItem(title: "PlanItem2", completionRate: "76%", graphValue: 0.3),
            CurrentItem(title: "PlanItem3", completionRate: "76%", graphValue: 0.7),
            CurrentItem(title: "PlanItem4", completionRate: "76%", graphValue: 0.2),
        ]
        financialPlanCurrentView.currentPlanCollectionView.reloadData()
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

// 이전 화면부터 여기까지 뎁스가 4단계까지 깊어져서 이 페이지까지 온다면 이전 쌓인 뷰들을 제거해줄 필요가 있었음. 회의로 뎁스가 조정되었고 추후 확실히 안정적이라 판단되면 삭제될 부분
extension FinancialPlanCurrentPlanVC {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController is FinancialPlanEditPlanVC {
            if let index = navigationController.viewControllers.firstIndex(of: viewController) {
                navigationController.viewControllers.removeSubrange(0..<index)
            }
        }
    }
}
