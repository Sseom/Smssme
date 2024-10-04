import UIKit

class FinancialPlanCompleteVC: UIViewController {
    private let completeView = FinancialPlanCompleteView()
    private let incompleteView = IncompleteView()
    private let planService: FinancialPlanService = FinancialPlanService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        completeView.collectionView.dataSource = self
        completeView.collectionView.delegate = self
        tabBarController?.tabBar.backgroundColor = .white
    }
    
    override func loadView() {
        view = planService.fetchCompletedFinancialPlans().isEmpty ? incompleteView : completeView
    }
}

extension FinancialPlanCompleteVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let completedPlans = planService.fetchCompletedFinancialPlans()
        guard indexPath.item < completedPlans.count else {
            return
        }
        
        let selectedPlan = completedPlans[indexPath.item]
        let confirmVC = CompleteModalVC(planDTO: selectedPlan)
        confirmVC.modalPresentationStyle = .pageSheet
        if let sheet = confirmVC.sheetPresentationController {
            sheet.detents = [.custom { _ in return 500 }]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = 30
        }
        
        present(confirmVC, animated: true, completion: nil)
    }
}
