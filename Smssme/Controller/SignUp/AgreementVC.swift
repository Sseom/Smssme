//
//  AgreementVC.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/8/24.
//

import UIKit

class AgreementVC: UIViewController {

    private let agreementView = AgreementView()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view = agreementView

        self.navigationItem.title = "회원가입-이용약관 동의"
    }
    

  
    //MARK: - @objc
    @objc func nextButtonTapped() {
        
    }

}
