//
//  PasswordVC.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/8/24.
//

import UIKit

class PasswordVC: UIViewController {
    private let passwordView = PasswordView()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = passwordView
        
        self.navigationItem.title = "회원가입-비밀번호"
          
    }
    
    //MARK: - @objc
    @objc func nextButtonTapped() {
        let nicknameVC = NickNameVC()
        navigationController?.pushViewController(nicknameVC, animated: true)
    }
    
}
