//
//  ViewModel.swift
//  Smssme
//
//  Created by KimRin on 10/15/24.
//

import Foundation
import RxSwift

protocol ViewModel {
    
    associatedtype Input
    associatedtype Output
    var disposeBag: DisposeBag { get set }
    
    func transform(_ input: Input) -> Output
}
