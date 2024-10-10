////
////  PlanCreationVM.swift
////  Smssme
////
////  Created by 임혜정 on 10/7/24.
////
//
//import RxSwift
//import RxCocoa
//import Foundation
//import UIKit
//
//class FinancialPlanCreationVM {
//    // Input
//    let planTitle: BehaviorRelay<String?>
//    let targetAmount = BehaviorRelay<String?>(value: nil)
//    let currentSaved = BehaviorRelay<String?>(value: nil)
//    let startDate = BehaviorRelay<Date>(value: Date())
//    let endDate = BehaviorRelay<Date>(value: Date())
//    
//    // Output
//    lazy var isInputValid: Observable<Bool> = Observable.combineLatest(
//        planTitle,
//        targetAmount,
//        currentSaved,
//        startDate,
//        endDate
//    ).map { [weak self] title, target, current, start, end in
//        guard let self = self else { return false }
//        return self.validateInputs(title: title, target: target, current: current, start: start, end: end)
//    }
//    
//    let errorMessage = PublishRelay<String>()
//    let showTooltip = BehaviorRelay<Bool>(value: true)
//    
//    let planService: FinancialPlanService
//    private let disposeBag = DisposeBag()
//    let planType: PlanType
//    
//    init(planService: FinancialPlanService = FinancialPlanService()) {
//        self.planService = planService
////        self.planType = planType
//        self.planTitle = BehaviorRelay<String?>(value: planType.title)
//    }
//    
//    private func validateInputs(title: String?, target: String?, current: String?, start: Date, end: Date) -> Bool {
//        // 기존 유효성 검사 로직을 그대로 유지
//        guard let title = title, !title.isEmpty else {
//            errorMessage.accept("제목을 입력해주세요.")
//            return false
//        }
//        
//        guard let targetText = target,
//              let targetAmount = KoreanCurrencyFormatter.shared.number(from: targetText),
//              targetAmount > 0 else {
//            errorMessage.accept("올바른 목표 금액을 입력해주세요.")
//            return false
//        }
//        
//        guard let currentText = current,
//              let currentAmount = KoreanCurrencyFormatter.shared.number(from: currentText),
//              currentAmount >= 0 else {
//            errorMessage.accept("올바른 현재 저축액을 입력해주세요.")
//            return false
//        }
//        
//        guard start < end else {
//            errorMessage.accept("종료 날짜는 시작 날짜보다 늦어야 합니다.")
//            return false
//        }
//        
//        return true
//    }
//    
//    func createPlan() -> Observable<FinancialPlanDTO> {
//        // 기존 createPlan 로직을 그대로 유지
//        return Observable.create { [weak self] observer in
//            guard let self = self,
//                  let title = self.planTitle.value,
//                  let targetAmountString = self.targetAmount.value,
//                  let currentSavedString = self.currentSaved.value,
//                  let targetAmount = KoreanCurrencyFormatter.shared.number(from: targetAmountString),
//                  let currentSaved = KoreanCurrencyFormatter.shared.number(from: currentSavedString) else {
//                observer.onError(NSError(domain: "입력 오류", code: 0, userInfo: nil))
//                return Disposables.create()
//            }
//            
//            do {
//                let newPlanDTO = try self.planService.createFinancialPlan(
//                    title: title,
//                    amount: targetAmount,
//                    deposit: currentSaved,
//                    startDate: self.startDate.value,
//                    endDate: self.endDate.value,
//                    planType: self.planType,
//                    isCompleted: false,
//                    completionDate: Date.distantFuture
//                )
//                observer.onNext(newPlanDTO)
//                observer.onCompleted()
//            } catch {
//                observer.onError(error)
//            }
//            
//            return Disposables.create()
//        }
//    }
//    
//    func checkExistingPlan(title: String) -> Observable<Bool> {
//        // 기존 checkExistingPlan 로직을 그대로 유지
//        return Observable.create { [weak self] observer in
//            guard let self = self else {
//                observer.onCompleted()
//                return Disposables.create()
//            }
//            
//            let exists = self.planService.getFinancialPlanByTitle(title) != nil
//            observer.onNext(exists)
//            observer.onCompleted()
//            
//            return Disposables.create()
//        }
//    }
//}
