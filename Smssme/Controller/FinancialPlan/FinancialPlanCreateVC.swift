//
//  FinancialPlanConfirmVC.swift
//  Smssme
//
//  Created by 임혜정 on 8/28/24.
//

import UIKit

protocol FinancialPlanDeleteDelegate: AnyObject {
    func didDeleteFinancialPlan(_ plan: FinancialPlanDTO)
}

protocol FinancialPlanUpdateDelegate: AnyObject {
    func didUpdateFinancialPlan(_ plan: FinancialPlanDTO)
}

class FinancialPlanConfirmVC: UIViewController, FinancialPlanEditDelegate {
    weak var deleteDelegate: FinancialPlanDeleteDelegate?
    weak var updateDelegate: FinancialPlanUpdateDelegate?
    
    private var centerImage: String = ""
    private let confirmView = FinancialPlanConfirmView()
    
    private let planService: FinancialPlanService
    private var planDTO: FinancialPlanDTO

    init(planService: FinancialPlanService, planDTO: FinancialPlanDTO) {
        self.planService = planService
        self.planDTO = planDTO
        super.init(nibName: nil, bundle: nil)
        
        self.centerImage = getImageName(for: planDTO.title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configure(with: planDTO)
//        repository.printAllFinancialPlans() 저장된 플랜 확인용
        setupButtonActions()
    }
    
    override func loadView() {
        view = confirmView
    }
    
    func didUpdateFinancialPlan(_ plan: FinancialPlanDTO) {
        self.planDTO = plan
        configure(with: plan)
        updateDelegate?.didUpdateFinancialPlan(plan)
    }
    
    private func configure(with plan: FinancialPlanDTO) {
        confirmView.confirmLargeTitle.text = "\(plan.title)"
        confirmView.confirmImage.image = UIImage(named: centerImage)
        confirmView.amountGoalLabel.text = "\(plan.amount.formattedAsCurrency)원"
        confirmView.currentSavedLabel.text = "\(plan.deposit.formattedAsCurrency)원"
        confirmView.endDateLabel.text = FinancialPlanDateModel.dateFormatter.string(from: plan.endDate)
        
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day], from: now, to: plan.endDate)
        if let daysLeft = components.day {
            confirmView.daysLeftLabel.text = "\(daysLeft)일"
        }
    }
    
    private func getImageName(for title: String) -> String {
            switch title {
            case "잊지못할 인생여행":
                return "travelConfirm"
            case "드림카 프로젝트":
                return "carConfirm"
            case "내집 마련의 꿈":
                return "houseConfirm"
            case "로맨틱 결혼식":
                return "weddingConfirm"
            case "황금빛 은퇴자금":
                return "retirementConfirm"
            default:
                return "myPlanConfirm"
            }
        }
}

// MARK: - 버튼 액션 관련
extension FinancialPlanConfirmVC {
    private func setupButtonActions() {
        confirmView.editButton.addAction(UIAction(handler: { [weak self] _ in
            self?.editButtonTapped()
        }), for: .touchUpInside)
        
        confirmView.deleteButton.addAction(UIAction(handler: { [weak self] _ in
            self?.deleteButtonTapped()
        }), for: .touchUpInside)
    }
    
    private func editButtonTapped() {
        let financialPlanEditPlanVC = FinancialPlanEditPlanVC(planService: planService, planDTO: planDTO)
        financialPlanEditPlanVC.editDelegate = self
        navigationController?.pushViewController(financialPlanEditPlanVC, animated: true)
    }
    
    private func deleteButtonTapped() {
        let alert = UIAlertController(title: "플랜 삭제", message: "정말로 이 플랜을 삭제하시겠습니까?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { [weak self] _ in
            self?.deletePlan()
        }))
        
        present(alert, animated: true)
    }
    
    private func deletePlan() {
        do {
            try planService.deleteFinancialPlan(planDTO)
            deleteDelegate?.didDeleteFinancialPlan(planDTO)
            // 모든 플랜이 삭제되었는지 확인
            if planService.fetchAllFinancialPlans().isEmpty {
                showAlert(message: "모든 플랜이 삭제되었습니다.") { [weak self] in
                    self?.navigateToSelectionVC()
                }
            } else {
                showAlert(message: "플랜이 성공적으로 삭제되었습니다.") { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        } catch {
            showAlert(message: "삭제 중 오류발생했습니다\(error.localizedDescription)")
        }
    }
    
    private func navigateToSelectionVC() {
        let tabBar = TabBarController()
        
        tabBar.selectedIndex = 2
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = tabBar
            window.makeKeyAndVisible()
        }
    }
    
    private func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
}
