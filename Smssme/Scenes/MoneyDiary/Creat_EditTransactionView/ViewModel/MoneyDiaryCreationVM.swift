//
//  11.swift
//  Smssme
//
//  Created by KimRin on 10/12/24.
//

import Foundation
import RxSwift

class MoneyDiaryCreationVM: ViewModel {
    var disposeBag = DisposeBag()
    
    struct Input {
        let tap: Observable<TransactionItem>
    }
    struct Output {}
    
    
    
    init() {}
    
    func transform(_ input: Input) -> Output {
        .init()
    }
    
    
}
