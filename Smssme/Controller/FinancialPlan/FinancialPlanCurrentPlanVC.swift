//
//  FinancialPlanCurrentPlanVC.swift
//  Smssme
//
//  Created by 임혜정 on 8/29/24.
//

import UIKit

final class FinancialPlanCurrentPlanVC: UIViewController, FinancialPlanCreationDelegate, FinancialPlanEditDelegate, FinancialPlanDeleteDelegate, FinancialPlanUpdateDelegate {
    
    private let financialPlanCurrentView = FinancialPlanCurrentPlanView()
    private let planItemStore = PlanItemStore.shared
    private let repository: FinancialPlanRepository
    private var plans: [FinancialPlan] = []
    
    init(repository: FinancialPlanRepository = FinancialPlanRepository()) {
        self.repository = repository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupAddPlanButtonAction()
        financialPlanCurrentView.currentPlanCollectionView.dataSource = self
        financialPlanCurrentView.currentPlanCollectionView.delegate = self
        loadFinancialPlans()
    }
    
    override func loadView() {
        view = financialPlanCurrentView
    }

    private func loadFinancialPlans() {
        plans = repository.getAllFinancialPlans()
        financialPlanCurrentView.currentPlanCollectionView.reloadData()
    }
    
    private func setupAddPlanButtonAction() {
        financialPlanCurrentView.onAddPlanButtonTapped = { [weak self] in
            self?.actionAddPlanButton()
        }
    }
}

extension FinancialPlanCurrentPlanVC {
    func actionAddPlanButton() {
        let financialPlanSelectionVC = FinancialPlanSelectionVC()
        navigationController?.pushViewController(financialPlanSelectionVC, animated: true)
    }
}

extension FinancialPlanCurrentPlanVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return plans.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FinancialPlanCurrentPlanCell.ID, for: indexPath) as? FinancialPlanCurrentPlanCell else {
            return UICollectionViewCell()
        }
        
        let item = plans[indexPath.item]
        cell.configure(item: item, repository: repository)
        return cell
    }
}

extension FinancialPlanCurrentPlanVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPlan = plans[indexPath.item]
        let confirmVC = FinancialPlanConfirmVC(financialPlanManager: FinancialPlanManager.shared, financialPlan: selectedPlan, repository: FinancialPlanRepository())
        confirmVC.deleteDelegate = self
        confirmVC.updateDelegate = self
        navigationController?.pushViewController(confirmVC, animated: true)
    }
    
    func didCreateFinancialPlan(_ plan: FinancialPlan) {
        plans.insert(plan, at: 0)
        DispatchQueue.main.async {
            self.financialPlanCurrentView.currentPlanCollectionView.reloadData()
        }
    }
    
    func didDeleteFinancialPlan(_ plan: FinancialPlan) {
        if let index = plans.firstIndex(where: { $0.id == plan.id }) {
            plans.remove(at: index)
            DispatchQueue.main.async {
                self.financialPlanCurrentView.currentPlanCollectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
            }
        }
    }
    
    func didUpdateFinancialPlan(_ plan: FinancialPlan) {
        if let index = plans.firstIndex(where: { $0.id == plan.id }) {
            plans[index] = plan
            DispatchQueue.main.async {
                self.financialPlanCurrentView.currentPlanCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
            }
        }
    }
}

// 이전 화면부터 여기까지 뎁스가 4단계까지 깊어져서 이 페이지까지 온다면 이전 쌓인 뷰들을 제거해줄 필요가 있었음. 회의로 뎁스가 조정되었고 추후 확실히 안정적이라 판단되면 삭제될 부분
extension FinancialPlanCurrentPlanVC {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController is FinancialPlanCurrentPlanVC {
            if let index = navigationController.viewControllers.firstIndex(of: viewController) {
                navigationController.viewControllers.removeSubrange(0..<index)
            }
        }
    }
}
