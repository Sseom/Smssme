//
//  FinancialPlanCurrentPlanVC.swift
//  Smssme
//
//  Created by 임혜정 on 8/29/24.
//

import UIKit

final class FinancialPlanCurrentPlanVC: UIViewController {
    private let financialPlanCurrentView: FinancialPlanCurrentPlanView

    init(financialPlanCurrentView: FinancialPlanCurrentPlanView) {
        self.financialPlanCurrentView = financialPlanCurrentView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        view = financialPlanCurrentView
    }
}
