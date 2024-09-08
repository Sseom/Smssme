//
//  IncomeAndLocationVC.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/8/24.
//

import UIKit

class IncomeAndLocationVC: UIViewController {
    private let incomeAndLocationView = IncomeAndLocationView()

    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view = incomeAndLocationView
        
        self.navigationItem.title = "회원가입-소득 및 지역"
        
    
    }
    

    //MARK: - @objc
    @objc func nextButtonTapped() {
        let agreementVC = AgreementVC()
        navigationController?.pushViewController(agreementVC, animated: true)
    }
}
