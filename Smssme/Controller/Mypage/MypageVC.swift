//
//  MypageVC.swift
//  Smssme
//
//  Created by ahnzihyeon on 8/29/24.
//

import FirebaseAuth
import FirebaseFirestore
import UIKit

class MypageVC: UIViewController {
    
    private let mypageView = MypageView()
    
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = mypageView
        
        setupAddtarget()
        
        checkLoginStatus()
        
    }
    
    
    //MARK: - func
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
    
    // TODO: 파베에서 현재 사용자를 가져올 때 권장하는 방법은 다음과 같이 Auth 객체에 리스너를 설정 해볼 것.
    
    // 현재 로그인한 사용자 아이디(이메일 정보)
    private func checkLoginStatus() {
        if let user  = Auth.auth().currentUser {
            // 로그인 상태라면
            print("사용자 uid: \(user.uid)")
            
            loadUserData(uid: user.uid)
            
            mypageView.userEmailLabel.text = "로그인 정보: \(user.email ?? "알 수 없는 이메일입니다.)")"
            
        } else {
            // 비로그인 상태라면
            mypageView.userEmailLabel.text = "로그인해주세요."
        }
    }
    
    
    //MARK: - loadUserData: 파이어베이스 사용자 회원가입 정보 읽기
    func loadUserData(uid: String) {
        //        db.collection("users").getDocuments { (snapshot, error) in
        //            if error == nil && snapshot != nil {
        //                for document in snapshot!.documents {
        //                    print(document.documentID)
        //                }
        //            } else {
        //                print("loadUserData 실패. \(error)")
        //            }
        //        }

        
        if let user  = Auth.auth().currentUser {
            db.collection("users").document(uid).getDocument { (snapshot, error) in
                if let error = error {
                    print("Error fetching user data: \(error.localizedDescription)")
                    return
                }
                
                guard let data = snapshot?.data() else {
                    print("No data found")
                    return
                }
                
                self.updateLabels(with: data)
            }
        }
    }
    
    func updateLabels(with data: [String: Any]) {
        if let nickname = data["nickname"] as? String {
            mypageView.nicknameLabel.text = "닉네임: \(nickname)"
        }
        
        if let birthday = data["birthday"] as? String {
            mypageView.birthdayLabel.text = "생년월일: \(birthday)"
        }
        
        if let gender = data["gender"] as? String {
            mypageView.genderLabel.text = "성별: \(gender)"
        }
        
        if let income = data["income"] as? String {
            mypageView.incomeLabel.text = "소득: \(income)"
        }
        
        if let location = data["location"] as? String {
            mypageView.locationLabel.text = "지역: \(location)"
        }
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
    
    //MARK: - @objc 회원탈퇴
    @objc func deleteUserButtonTapped() {
        if let user = Auth.auth().currentUser {
            user.delete { [self] error in
                if let error = error {
                    showAlert(message: "\(error)", AlertTitle: "오류 발생", buttonClickTitle: "확인 ")
                } else {
                    showSnycAlert(message: "회원탈퇴되었습니다.", AlertTitle: "회원탈퇴 성공", buttonClickTitle: "확인", method: switchToLoginVC)
                }
            }
        } else {
            showAlert(message: "오류 발생", AlertTitle: "로그인 정보가 존재하지 않습니다", buttonClickTitle: "확인")
        }
        
    }
    
}
