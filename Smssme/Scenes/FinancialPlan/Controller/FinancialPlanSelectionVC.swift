//
//  FinancialPlanSelectVC.swift
//  Smssme
//
//  Created by 임혜정 on 8/27/24.
//

import CoreData
import UIKit
import RxSwift

protocol FinancialPlanCreateDelegate: AnyObject {
    func didCreateFinancialPlan(_ plan: FinancialPlanDTO)
}
final class FinancialPlanSelectionVC: UIViewController {
    weak var createDelegate: FinancialPlanEditDelegate?
    private let selectionView = FinancialPlanSelectionView()
    private let viewModel: FinancialPlanSelectionVM = FinancialPlanSelectionVM()
    private let disposeBag = DisposeBag()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.backgroundColor = .white
        bindViewModel()
    }
    
    override func loadView() {
        view = selectionView
    }
    
    private func bindViewModel() {
        // 인풋
        selectionView.collectionView.rx.itemSelected
            .withLatestFrom(viewModel.planTypes) { indexPath, planTypes in
                planTypes[indexPath.item]
            }
            .bind(to: viewModel.selectPlan)
            .disposed(by: disposeBag)
        
        // 아웃풋
        viewModel.planTypes
            .bind(to: selectionView.collectionView.rx.items(cellIdentifier: FinancialPlanCell.ID, cellType: FinancialPlanCell.self)) { _, planType, cell in
                cell.configure(with: planType)
                cell.cellBackgroundColor(UIColor(hex: "#ffffff"))
            }
            .disposed(by: disposeBag)
        
        viewModel.showExistingPlanAlert
            .subscribe(onNext: { [weak self] in
                self?.showExistingPlanAlert()
            })
            .disposed(by: disposeBag)
        
        viewModel.navigateToCreatePlan
            .subscribe(onNext: { [weak self] planType in
                self?.navigateToCreatePlan(with: planType)
            })
            .disposed(by: disposeBag)
        
        viewModel.navigateToCurrentPlanScreen
            .subscribe(onNext: { [weak self] in
                self?.navigateToCurrentPlanVC()
            })
            .disposed(by: disposeBag)
    }
    
    private func showExistingPlanAlert() {
        showSyncAlert2(
            message: "동시에 진행 가능한 플랜은 10개입니다. 플랜을 삭제하거나 완료해주세요",
            AlertTitle: "알림",
            leftButtonTitle: "현재 플랜 보기",
            leftButtonmethod: { [weak self] in
                self?.viewModel.navigateToCurrentPlan.onNext(())
            },
            rightButtonTitle: "취소",
            rightButtonmethod: { }
        )
    }
    
    private func navigateToCreatePlan(with planType: PlanType) {
        let createPlanVC = FinancialPlanCreationVC(viewModel: FinancialPlanCreationViewModel(planService: FinancialPlanService(), selectedPlanType: planType))
//        createPlanVC.configure(with: planType.title, planType: planType)
        navigationController?.pushViewController(createPlanVC, animated: true)
    }
    
    private func navigateToCurrentPlanVC() {
        let currentPlanVC = FinancialPlanCurrentPlanVC(planService: viewModel.planService)
        navigationController?.pushViewController(currentPlanVC, animated: true)
    }
}
