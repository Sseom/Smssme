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
            PlanItem(title: "잊지못할 인생여행", description: "꿈꿔왔던 그곳을 가기위한 나의 인생여행 자금 마련 플랜"),
            PlanItem(title: "드림카 프로젝트", description: "나만의 드림카를 갖는 그날을 위한 드림카플랜"),
            PlanItem(title: "내집 마련의 꿈", description: "미래의 나의 보금자리를 위한 첫걸음, 내집마련 플랜"),
            PlanItem(title: "로맨틱 결혼식", description: "새로운 삶의 시작인 그 행복한 순간을 위한 결혼자금 플랜"),
            PlanItem(title: "황금빛 은퇴자금", description: "편안한 은퇴를 위한 준비, 빨리 시작할수록 든든합니다!"),
            PlanItem(title: "나만의 플랜 설정", description: "편안한 은퇴를 위한 준비, 빨리 시작할수록 든든합니다!"),
            
        ]
        financialPlanSelectionView.collectionView.reloadData()
    }
    
    @objc private func addButtonTapped() {
        planItems.append(PlanItem(title: "나만의 플랜 설정", description: "나만의 자산목표를 설정하고 체계적으로 이루어 보세요"))
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

extension FinancialPlanSelectionVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item < planItems.count {
            let createPlanVC = FinancialPlanCreateVC(textFieldArea: CreatePlanTextFieldView())
            navigationController?.pushViewController(createPlanVC, animated: true)
        }
    }
}
