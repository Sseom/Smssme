//
//  FinancialPlanConfirmVC.swift
//  Smssme
//
//  Created by 임혜정 on 8/28/24.
//

import UIKit

class FinancialPlanConfirmVC: UIViewController {
    private let financialPlanConfirmView: FinancialPlanConfirmView
    
    init(financialPlanConfirmView: FinancialPlanConfirmView) {
        self.financialPlanConfirmView = financialPlanConfirmView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        print("플랜확인창으로 이동되었습니다")
    }
    
    override func loadView() {
        view = financialPlanConfirmView
    }
}
