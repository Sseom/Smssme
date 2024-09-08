//
//  NickNameVC.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/8/24.
//

import UIKit

class NickNameVC: UIViewController {
    private let nicknameView = NickNameView()

    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view = nicknameView
        
        self.navigationItem.title = "회원가입-닉네임"
        
       
    }
    

    //MARK: - @objc
    @objc func nextButtonTapped() {
        let incomeAndLocationVC = IncomeAndLocationVC()
        navigationController?.pushViewController(incomeAndLocationVC, animated: true)
    }

}
