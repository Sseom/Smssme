//
//  FinancialPlanSelectVC.swift
//  Smssme
//
//  Created by 임혜정 on 8/27/24.
//

import CoreData
import UIKit

import FirebaseAuth

extension FinancialPlanSelectionVC {
    private func migrateDataToFirebase() {
        guard Auth.auth().currentUser != nil else {
            print("사용자가 로그인되어 있지 않습니다.")
            return
        }
        
        // 마이그레이션 시작
        planService.migrateFinancialPlansToFirebase { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("모든 금융 계획이 성공적으로 마이그레이션되었습니다.")
                    self?.updateUIAfterMigration()
                case .failure(let error):
                    print("마이그레이션 실패: \(error)")
//                    self?.showMigrationErrorAlert(error: error)
                    self?.showAlert(message: "데이터 마이그레이션 중 오류가 발생했습니다: \(error.localizedDescription)", AlertTitle: "마이그레이션 오류", buttonClickTitle: "확인")
                }
            }
        }
    }
    
    private func updateUIAfterMigration() {
        // 어쩌면 ui업데이트가 필요한가??
    }
    
    private func syncDataFromFirebase() {
        guard Auth.auth().currentUser != nil else {
            print("사용자가 로그인되어 있지 않습니다.")
            return
        }
        
        FirebaseFirestoreManager.shared.syncFinancialPlansToCoreData { result in
            switch result {
            case .success():
                print("데이터 동기화 완료")
            case .failure(let error):
                print("동기화 실패: \(error)")
            }
        }
    }
}

protocol FinancialPlanCreateDelegate: AnyObject {
    func didCreateFinancialPlan(_ plan: FinancialPlanDTO)
}

final class FinancialPlanSelectionVC: UIViewController {
    weak var createDelegate: FinancialPlanEditDelegate?
    private let selectionView = FinancialPlanSelectionView()
    private let planService: FinancialPlanService = FinancialPlanService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectionView.collectionView.dataSource = self
        selectionView.collectionView.delegate = self
        view.backgroundColor = UIColor(hex: "#e9f3fd")
        tabBarController?.tabBar.backgroundColor = .white
        
        //        migrateDataToFirebase()
        syncDataFromFirebase()
        //        planService.deleteIncompleteItems()
        //        print("디버깅데이터: \(planService.fetchAllFinancialPlans())")
    }
    
    override func loadView() {
        view = selectionView
    }
}

// MARK: - Collection View Data Source
extension FinancialPlanSelectionVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PlanType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FinancialPlanCell.ID, for: indexPath) as? FinancialPlanCell else {
            return UICollectionViewCell()
        }
        
        let planType = PlanType.allCases[indexPath.item]
        cell.configure(with: planType)
        cell.cellBackgroundColor(UIColor(hex: "#ffffff"))
        
        return cell
    }
}

// MARK: - Collection View Delegate
extension FinancialPlanSelectionVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPlanType = PlanType.allCases[indexPath.item]
        let planTitle = selectedPlanType.title
        
        if planService.fetchIncompletedPlans().count >= 10 {
            showExistingPlanAlert()
        } else {
            let createPlanVC = FinancialPlanCreationVC(planService: planService)
            createPlanVC.configure(with: planTitle, planType: selectedPlanType)
            navigationController?.pushViewController(createPlanVC, animated: true)
        }
    }
    
    private func showExistingPlanAlert() {
        showSyncAlert2(
            message: "동시에 진행 가능한 플랜은 10개입니다. 플랜을 삭제하거나 완료해주세요",
            AlertTitle: "알림",
            leftButtonTitle: "현재 플랜 보기",
            leftButtonmethod: { [weak self] in
                self?.navigateToCurrentPlanVC()
            },
            rightButtonTitle: "취소",
            rightButtonmethod: { }
        )
    }
    
    private func navigateToCurrentPlanVC() {
        let currentPlanVC = FinancialPlanCurrentPlanVC(planService: planService)
        navigationController?.pushViewController(currentPlanVC, animated: true)
    }
}
