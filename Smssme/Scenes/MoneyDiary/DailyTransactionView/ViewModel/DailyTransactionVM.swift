// DailyTransactionViewModel.swift
import Foundation
import RxSwift
import RxCocoa

final class DailyTransactionViewModel {
    private let disposeBag = DisposeBag()

    var transactionList = BehaviorRelay<[Diary]>(value: [])
    private var incomeTotalAmount = BehaviorRelay(value: "")
    private var expenseTotalAmount = BehaviorRelay(value: "")
    
    private let today: Date
    
    init(today: Date) {
        self.today = today
    }
    
    func transform(_ input: Input) -> Output {
        input.load
            .withUnretained(self)
            .subscribe(onNext: {owner, _ in
                owner.fetchTransactionList()
            })
            .disposed(by: disposeBag)
        
        return Output(transactionList: transactionList.asObservable(),
                      incomeString: incomeTotalAmount.asObservable(),
                      expenseString: expenseTotalAmount.asObservable()
        )
        
    }
    
    private func fetchTransactionList() {
        
        if let todayLists = DiaryCoreDataManager.shared.fetchDiaries(on: today) {
            transactionList.accept(todayLists)
            var incomeAmount = 0
            var expesneAmount = 0
            
            for item in todayLists {
                if item.statement {
                    incomeAmount += Int(item.amount)
                } else {
                    expesneAmount += Int(item.amount)
                }
            }
            let imcomeString = KoreanCurrencyFormatter.shared.string(from: incomeAmount)
            let expenseString = KoreanCurrencyFormatter.shared.string(from: expesneAmount)

            incomeTotalAmount.accept("수입: \(imcomeString) 원")
            expenseTotalAmount.accept("지출: \(expenseString) 원")
            
        }
    }
    

    
    
    
    
    
    struct Input {
        let load: Observable<Void>
    }
    
    struct Output {
        let transactionList: Observable<[Diary]>
        let incomeString: Observable<String>
        let expenseString: Observable<String>
    }
}
