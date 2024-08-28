//
//  FinancialPlanSelectVC.swift
//  Smssme
//
//  Created by 임혜정 on 8/27/24.
//

import UIKit

final class FinancialPlanSelectionVC: UIViewController {
    private let financialPlanSelectionView: FinancialPlanSelectionView
    private var planItems: [PlanItem] = []

    init(financialPlanSelectionView: FinancialPlanSelectionView) {
        self.financialPlanSelectionView = financialPlanSelectionView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        financialPlanSelectionView.collectionView.dataSource = self
        financialPlanSelectionView.collectionView.delegate = self
        fetchItems()
    }
    
    override func loadView() {
        view = financialPlanSelectionView
        view.backgroundColor = .white
    }
    
    // 더미 데이터 - 분리 예정
    struct PlanItem {
        let title: String
        let description: String
    }
    
    private func fetchItems() {
        planItems = [
            PlanItem(title: "PlanItem1", description: "description1"),
            PlanItem(title: "PlanItem2", description: "description2"),
            PlanItem(title: "PlanItem3", description: "description3"),
            PlanItem(title: "PlanItem4", description: "description4"),
            PlanItem(title: "PlanItem5", description: "description4"),
            PlanItem(title: "PlanItem6", description: "description4"),
        ]
        financialPlanSelectionView.collectionView.reloadData()
    }
}

// MARK: - 콜렉션 뷰
extension FinancialPlanSelectionVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return planItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FinancialPlanCell.ID, for: indexPath) as? FinancialPlanCell else {
            return UICollectionViewCell()
        }
        let item = planItems[indexPath.item]
        cell.configure(with: item)
        return cell
    }
}

extension FinancialPlanSelectionVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let navigationController = self.navigationController else {
            print("네비게이션이업사요")
            return
        }
        
        let createPlanVC = FinancialPlanCreateVC(financialPlanCreateView: FinancialPlanCreateView())
        navigationController.pushViewController(createPlanVC, animated: true)
        
    }
}
