//
//  UIViewController+Reactive.swift
//  Smssme
//
//  Created by KimRin on 10/7/24.
//

import UIKit

import RxCocoa
import RxSwift

extension Reactive where Base: UIViewController {
    var viewWillAppear: Observable<Void> {
        return methodInvoked(#selector(Base.viewWillAppear(_:)))
            .map{ _ in}
    }
    
}
