//
//  MypageViewController.swift
//  Smssme
//
//  Created by ahnzihyeon on 8/29/24.
//

import FirebaseAuth
import UIKit

class MypageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    //MARK: - @objc 로그아웃
    @objc func logOutButtonTapped() {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            showAlert(message: "로그아웃되었습니다.", AlertTitle: "로그아웃", buttonClickTitle: "확인")
        } catch let error {
            print(error.localizedDescription)
        }
    }

}
