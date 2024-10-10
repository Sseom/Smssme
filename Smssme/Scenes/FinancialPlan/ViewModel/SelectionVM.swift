//
//  SelectionVM.swift
//  Smssme
//
//  Created by 임혜정 on 10/4/24.
//

import RxCocoa
import RxSwift

class FinancialPlanSelectionVM {
    //인풋
    let selectPlan = PublishSubject<PlanType>()
    let navigateToCurrentPlan = PublishSubject<Void>()
    
    //아웃풋
    let planTypes: Observable<[PlanType]>
    let showExistingPlanAlert: Observable<Void>
    let navigateToCreatePlan: Observable<PlanType>
    let navigateToCurrentPlanScreen: Observable<Void>
    
    let planService: FinancialPlanService = FinancialPlanService()
    private let disposeBag = DisposeBag()
    
    init() {
//        self.planService = planService
//        
        planTypes = .just(PlanType.allCases)
        
        let incompletedPlansCount = planService.fetchIncompletedPlans().count
        
        showExistingPlanAlert = selectPlan
            .filter { _ in incompletedPlansCount >= 10 }
            .map { _ in }
        
        navigateToCreatePlan = selectPlan
            .filter { _ in incompletedPlansCount < 10 }
        
        navigateToCurrentPlanScreen = navigateToCurrentPlan.asObservable()
    }
}
