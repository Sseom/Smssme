//
//  FinancialPlanCreateVC.swift
//  Smssme
//
//  Created by 임혜정 on 8/27/24.
//

import CoreData
import UIKit
import SafariServices
import RxSwift
import RxCocoa

protocol FinancialPlanCreationDelegate: AnyObject {
    func didCreateFinancialPlan(_ plan: FinancialPlanDTO)
}

class FinancialPlanCreationViewModel {
    // 인풋
    let planTitle = BehaviorRelay<String?>(value: nil)
    let amount = BehaviorRelay<String?>(value: nil)
    let deposit = BehaviorRelay<String?>(value: nil)
    let startDate = BehaviorRelay<Date>(value: Date())
    let endDate = BehaviorRelay<Date>(value: Date())
    let saveTrigger = PublishSubject<Void>()
    let titleIsDuplicate = PublishSubject<Bool>()
    
    // 아웃풋
    lazy var isValidInput: Observable<Bool> = {
        return Observable.combineLatest(planTitle, amount, startDate, endDate)
            .map { [weak self] title, amount, start, end in
                guard let self = self else { return false }
                return self.validateInputs(title: title, amount: amount, start: start, end: end)
            }
    }()
    
    let saveResult = PublishSubject<Result<FinancialPlanDTO, Error>>()
    lazy var showTooltip: Observable<Bool> = {
        return self.planTitle.map { $0 == self.selectedPlanType.title }
    }()
    
    private let disposeBag = DisposeBag()
    let planService: FinancialPlanService
    let selectedPlanType: PlanType
    
    init(planService: FinancialPlanService, selectedPlanType: PlanType) {
        self.planService = planService
        self.selectedPlanType = selectedPlanType
        
        isValidInput = Observable.combineLatest(planTitle, amount, startDate, endDate)
            .map { [weak self] title, amount, start, end in
                guard let self = self else { return false }
                return self.validateInputs(title: title, amount: amount, start: start, end: end)
            }
        
        showTooltip = planTitle.map { $0 == selectedPlanType.title }
        
        
    }
    
    private func setupSaveTrigger() {
        saveTrigger
            .withLatestFrom(Observable.combineLatest(planTitle, amount, deposit, startDate, endDate))
            .flatMapLatest { [weak self] title, amount, deposit, start, end -> Observable<Result<FinancialPlanDTO, Error>> in
                guard let self = self,
                      let title = title,
                      let amountValue = KoreanCurrencyFormatter.shared.number(from: amount ?? ""),
                      let depositValue = KoreanCurrencyFormatter.shared.number(from: deposit ?? "") else {
                    return .just(.failure(NSError(domain: "Invalid Input", code: 0, userInfo: nil)))
                }
                
                return Observable.create { observer in
                    do {
                        let newPlan = try self.planService.createFinancialPlan(
                            title: title,
                            amount: amountValue,
                            deposit: depositValue,
                            startDate: start,
                            endDate: end,
                            planType: self.selectedPlanType,
                            isCompleted: false,
                            completionDate: Date.distantFuture
                        )
                        observer.onNext(.success(newPlan))
                    } catch {
                        observer.onNext(.failure(error))
                    }
                    observer.onCompleted()
                    return Disposables.create()
                }
            }
            .bind(to: saveResult)
            .disposed(by: disposeBag)
    }
    
    private func validateInputs(title: String?, amount: String?, start: Date, end: Date) -> Bool {
        guard let title = title, !title.isEmpty,
              let amount = amount, !amount.isEmpty,
              let amountValue = KoreanCurrencyFormatter.shared.number(from: amount),
              amountValue > 0,
              end > start else {
            return false
        }
        
        let isDuplicate = planService.getFinancialPlanByTitle(title) != nil
        titleIsDuplicate.onNext(isDuplicate)
        return !isDuplicate
    }
    
    func checkTitleDuplication(_ title: String) {
        let isDuplicate = planService.getFinancialPlanByTitle(title) != nil
        titleIsDuplicate.onNext(isDuplicate)
    }
    
    func resetToPresetTitle() {
        planTitle.accept(selectedPlanType.title)
    }
    
    func getInfoLink() -> String {
        return selectedPlanType.infoLink
    }
}

class FinancialPlanCreationVC: UIViewController {
    private let viewModel: FinancialPlanCreationViewModel
    private let disposeBag = DisposeBag()
    
    private let creationView: FinancialPlanCreationView
    
    init(viewModel: FinancialPlanCreationViewModel) {
        self.viewModel = viewModel
        self.creationView = FinancialPlanCreationView(textFieldArea: CreatePlanTextFieldView())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        view = creationView
        creationView.titleTextField.text = viewModel.selectedPlanType.title
    }
    
    private func bindViewModel() {
        // 인풋
        creationView.titleTextField.rx.text
            .bind(to: viewModel.planTitle)
            .disposed(by: disposeBag)
        
        creationView.textFieldArea.targetAmountField.rx.text
            .bind(to: viewModel.amount)
            .disposed(by: disposeBag)
        
        creationView.textFieldArea.currentSavedField.rx.text
            .bind(to: viewModel.deposit)
            .disposed(by: disposeBag)
        
        creationView.confirmButton.rx.tap
            .bind(to: viewModel.saveTrigger)
            .disposed(by: disposeBag)
        
        viewModel.saveResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let plan):
                    self?.navigateToTabBar()
                case .failure(let error):
                    self?.showAlert(message: error.localizedDescription)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.showTooltip
            .bind(to: creationView.rx.isTooltipVisible)
            .disposed(by: disposeBag)
        
        creationView.titleTextField.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                if self.creationView.titleTextField.text == self.viewModel.selectedPlanType.title {
                    self.creationView.titleTextField.text = ""
                    self.creationView.hideTooltip()
                }
            })
            .disposed(by: disposeBag)
        
        creationView.titleTextField.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                if self.creationView.titleTextField.text?.isEmpty ?? true {
                    self.viewModel.resetToPresetTitle()
                }
            })
            .disposed(by: disposeBag)
        
        creationView.titleTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                self?.viewModel.checkTitleDuplication(text)
            })
            .disposed(by: disposeBag)
    }
    
    private func showExistingPlanAlert() {
        let alert = UIAlertController(title: "알림", message: "같은 제목의 플랜이 있습니다.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "제목수정", style: .cancel, handler: nil)
        
        let goToCurrentPlanAction = UIAlertAction(title: "진행 플랜 보러가기", style: .default) { [weak self] _ in
            self?.navigateToCurrentPlanVC()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(goToCurrentPlanAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func navigateToCurrentPlanVC() {
        let currentPlanVC = FinancialPlanCurrentPlanVC(planService: viewModel.planService)
        navigationController?.pushViewController(currentPlanVC, animated: true)
    }
    
    private func navigateToTabBar() {
        let tabBar = TabBarController()
        tabBar.selectedIndex = 2
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = tabBar
            window.makeKeyAndVisible()
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// 툴팁
extension Reactive where Base: FinancialPlanCreationView {
    var isTooltipVisible: Binder<Bool> {
        return Binder(self.base) { view, visible in
            if visible {
                view.showTooltip()
            } else {
                view.hideTooltip()
            }
        }
    }
}
