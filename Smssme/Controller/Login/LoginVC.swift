//
//  LoginVC.swift
//  Smssme
//
//  Created by ahnzihyeon on 8/27/24.
//

import UIKit

class LoginVC: UIViewController {
    
    private let loginVeiw = LoginView()
    
    override func loadView() {
        view = loginVeiw
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAddtarget()
    }
    
    func setupAddtarget() {
        //비회원 로그인 시
        loginVeiw.unLoginButton.addTarget(self, action: #selector(unloginButtonTapped), for: .touchUpInside)
    }
    
    //MARK: - @objc
    @objc private func unloginButtonTapped() {
        // 아직 메인 페이지 뷰컨이 없는 상태라 혜정님 뷰컨으로 임시 연결
        let vc = FinancialPlanSelectionVC(financialPlanSelectionView: FinancialPlanSelectionView())
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
