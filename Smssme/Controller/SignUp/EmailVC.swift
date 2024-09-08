//
//  LoginViewController.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/8/24.
//

import UIKit

class EmailVC: UIViewController {
    private let emailView = EmailView()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = emailView
        
        self.navigationItem.title = "회원가입-이메일 및 비밀번호"
    }
    
    //MARK: - @objc
    @objc func nextButtonTapped() {
        let passwordVC = PasswordVC()
        navigationController?.pushViewController(passwordVC, animated: true)
    }
    
}
