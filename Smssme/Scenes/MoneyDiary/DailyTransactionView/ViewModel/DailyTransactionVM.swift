// DailyTransactionViewModel.swift
import Foundation
import RxSwift
import RxCocoa

final class DailyTransactionViewModel {
    private let disposeBag = DisposeBag()
    private let transactionsRelay = BehaviorRelay<[Diary]>(value: [])
    
    var transactions: Driver<[Diary]> {
        return transactionsRelay.asDriver()
    }
    
    var dailyIncome: Driver<String> {
        return transactionsRelay
            .map { transactions in
                let incomeAmount = transactions.filter { $0.statement }.reduce(0) { $0 + Int($1.amount) }
                return "수입: " + KoreanCurrencyFormatter.shared.string(from: incomeAmount) + " 원"
            }
            .asDriver(onErrorJustReturn: "0 원")
    }
    
    var dailyExpense: Driver<String> {
        return transactionsRelay
            .map { transactions in
                let expenseAmount = transactions.filter { !$0.statement }.reduce(0) { $0 + Int($1.amount) }
                return "지출: " + KoreanCurrencyFormatter.shared.string(from: expenseAmount) + " 원"
            }
            .asDriver(onErrorJustReturn: "0 원")
    }
    
    func fetchTransactions(for date: Date) {
        let transactions = DiaryCoreDataManager.shared.fetchDiaries(on: date) ?? []
        transactionsRelay.accept(transactions)
    }
    
    func transaction(at index: Int) -> Diary {
        return transactionsRelay.value[index]
    }
    
    var transactionCount: Int {
        return transactionsRelay.value.count
    }
}
