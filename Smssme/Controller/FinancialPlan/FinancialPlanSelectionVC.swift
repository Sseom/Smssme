//
//  FinancialPlanSelectVC.swift
//  Smssme
//
//  Created by 임혜정 on 8/27/24.
//

import UIKit

final class FinancialPlanSelectionVC: UIViewController {
    private let financialPlanSelectionView = FinancialPlanSelectionView()
    private var planItems: [PlanItem] = []
    
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
            
        ]
        financialPlanSelectionView.collectionView.reloadData()
    }
    
    @objc private func addButtonTapped() {
        planItems.append(PlanItem(title: "New Plan", description: "New Description"))
        financialPlanSelectionView.collectionView.reloadData()
    }
}

// MARK: - 콜렉션 뷰
extension FinancialPlanSelectionVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return max(6, planItems.count + 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item < planItems.count {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FinancialPlanCell.ID, for: indexPath) as? FinancialPlanCell else {
                return UICollectionViewCell()
            }
            let item = planItems[indexPath.item]
            cell.configure(with: item)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddButtonCell.ID, for: indexPath) as? AddButtonCell else {
                return UICollectionViewCell()
            }
            cell.addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
            return cell
        }
    }
    
}

//extension FinancialPlanSelectionVC: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let createPlanVC = FinancialPlanCreateVC(textFieldArea: CreateTextView())
//        navigationController?.pushViewController(createPlanVC, animated: true)
//    }
//}

extension FinancialPlanSelectionVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item < planItems.count {
            let createPlanVC = FinancialPlanCreateVC(textFieldArea: CreatePlanTextFieldView())
            navigationController?.pushViewController(createPlanVC, animated: true)
        }
    }
}
