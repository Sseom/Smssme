////
////  FirebaseAuthenticationManager.swift
////  Smssme
////
////  Created by ahnzihyeon on 9/2/24.
////
//
//import FirebaseAuth
//
///// 사용자 회원가입, 로그인, 로그아웃, 회원탈퇴 등 Firebase Authentication 기능을 관리합니다.
//final class FirebaseAuthenticationManager {
//    static let shared = FirebaseAuthenticationManager()
//    
//    private init() {}
//    
//    //MARK: - registerUser: 파이어베이스 회원가입
//    func registerUser(email: String, password: String, nickname: String, birthday: String, gender: String, income: String, location: String) {
//        
//        // 회원가입
//        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
//            
//            if let error = error {
//                print("회원가입에 실패했습니다. 에러명 : \(error.localizedDescription)")
//                return
//            } else {
//                print("로그인 성공!!!")
//                
//                // 파이어베이스 유저 객체를 가져옴
//                guard let uid = authResult?.user.uid else { return }
//                
//                self.saveUserInfo(uid: uid, nickname: nickname, birthday: birthday, gender: gender, income: income, location: location)
//            }
//            
//            self.showAlert(message: "회원가입되었습니다.\n 감사합니다.", AlertTitle: "회원가입 완료", buttonClickTitle: "확인")
//            
//            let loginVC = LoginVC()
//            print("로그인 페이지로 전환")
//            self.navigationController?.popToRootViewController(animated: true)
//        }
//    }
//    
//    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
//        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
//            if let error = error {
//                completion(.failure(error))
//            } else if let user = authResult?.user {
//                completion(.success(user))
//            }
//        }
//    }
//    
//    
//    //MARK: - login: 파이어베이스 로그인
//    ///기존 사용자 로그인
//    ///기존 사용자가 자신의 이메일 주소와 비밀번호를 사용해 로그인할 수 있는 양식을 만듭니다. 사용자가 양식을 작성하면 signIn 메서드를 호출합니다.
//    func login(email: String, password: String) {
//        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
//            guard let self = self else { return }
//            // 에러가 나거나 유저가 없을 경우
//            if let error = error, user == nil {
//                showAlert(message: "\(error)", AlertTitle: "로그인 실패", buttonClickTitle: "확인")
//                
//            } else {
//                showSnycAlert(message: "안녕하세요,\n 로그인되었습니다.", AlertTitle: "로그인 성공", buttonClickTitle: "확인", method: switchToTabBarController)
//                
//            }
//        }
//    }
//    
//    //MARK: - logout: 파이어베이스 로그아웃
//    func logout() {
//        do {
//            try FirebaseAuth.Auth.auth().signOut()
//            print("로그아웃하고 페이지 전환")
//            
//            showSnycAlert(message: "로그아웃되었습니다.", AlertTitle: "로그아웃", buttonClickTitle: "확인", method: switchToLoginVC)
//        } catch let error {
//            print(error.localizedDescription)
//        }
//    }
//    
//    //MARK: - deleteUser: 파이어베이스 회원탈퇴
//    func deleteUser() {
//        if let user = Auth.auth().currentUser {
//            user.delete { [self] error in
//                if let error = error {
//                    showAlert(message: "\(error)", AlertTitle: "오류 발생", buttonClickTitle: "확인 ")
//                } else {
//                    showSnycAlert(message: "회원탈퇴되었습니다.", AlertTitle: "회원탈퇴 성공", buttonClickTitle: "확인", method: switchToLoginVC)
//                }
//            }
//        } else {
//            showAlert(message: "오류 발생", AlertTitle: "로그인 정보가 존재하지 않습니다", buttonClickTitle: "확인")
//        }
//    }
//}
