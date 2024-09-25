//
//  FinancialPlanCompleteVC.swift
//  Smssme
//
//  Created by 임혜정 on 9/24/24.
//

import UIKit

class FinancialPlanCompleteVC: UIViewController {
    private let completeView = FinancialPlanCompleteView()
    private let planService: FinancialPlanService = FinancialPlanService()
    private let planDTO: FinancialPlanDTO?
    
    init(planDTO: FinancialPlanDTO? = nil) {
        self.planDTO = planDTO
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        completeView.collectionView.dataSource = self
        completeView.collectionView.delegate = self
//        let service = FinancialPlanService()
//        do {
//            try service.deleteAllCompletedPlans()
//        } catch {
//            print("Error deleting completed plans: \(error)")
//        }
//        
    }
    
    override func loadView() {
        view = completeView
    }


}

extension FinancialPlanCompleteVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("\(planService.fetchCompletedFinancialPlans().count)")
        return planService.fetchCompletedFinancialPlans().count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FinancialPlanCompleteCell.ID, for: indexPath) as? FinancialPlanCompleteCell else {
            return UICollectionViewCell()
        }
        
        let plans = planService.fetchCompletedFinancialPlans()
            cell.configure(with: plans[indexPath.item])
            return cell
    }
}

extension FinancialPlanCompleteVC: UICollectionViewDelegate {
    
}
