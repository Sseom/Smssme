//
//  MypageViewController.swift
//  Smssme
//
//  Created by ahnzihyeon on 8/29/24.
//

import FirebaseAuth
import UIKit

class MypageViewController: UIViewController {
    
    private let mypageView = MypageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = mypageView
        print("MypageVC 진입완료!!!")
        
        setupAddtarget()
        
    }
    
    private func setupAddtarget() {
        // 로그아웃 버튼 이벤트
        mypageView.logoutButton.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
        
        // 회원탈퇴 버튼 이벤트
        mypageView.deleteUserButton.addTarget(self, action: #selector(deleteUserButtonTapped), for: .touchUpInside)
    }
    
    // 로그인VC으로 화면전환
    private func switchToLoginVC() {
        let loginVC = LoginVC()
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        window.rootViewController = loginVC
        window.makeKeyAndVisible()
    }
    
    //MARK: - @objc 로그아웃
    @objc func logOutButtonTapped() {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            print("로그아웃하고 페이지 전환")
            
//            showAlert(message: "로그아웃되었습니다.", AlertTitle: "로그아웃", buttonClickTitle: "확인")
            showSnycAlert(message: "로그아웃되었습니다.", AlertTitle: "로그아웃", buttonClickTitle: "확인", method: switchToLoginVC)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @objc func deleteUserButtonTapped() {
        
        if  let user = Auth.auth().currentUser {
            user.delete { [self] error in
                if let error = error {
                    showAlert(message: "\(error)", AlertTitle: "오류 발생", buttonClickTitle: "확인 ")
                } else {
                    showAlert(message: "회원탈퇴되었습니다.", AlertTitle: "회원탈퇴 성공", buttonClickTitle: "확인")
                }
            }
        } else {
            showAlert(message: "오류 발생", AlertTitle: "로그인 정보가 존재하지 않습니다", buttonClickTitle: "확인")
        }
        
    }
    
}
