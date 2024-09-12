//
//  FirebaseFirestoreManager.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/2/24.
//

import FirebaseFirestore
import FirebaseAuth


//// 모델로 추후 뺄 예정
//struct UserProfile {
//    let email: String
//    let nickName: String
//    let birthday: String
//    let gender: String
//    let income: String
//    let location: String
//}


/// Firestore 데이터베이스와 관련된 CRUD(생성, 읽기, 업데이트, 삭제) 작업을 관리합니다.
final class FirebaseFirestoreManager {
    static let shared = FirebaseFirestoreManager()
     
    private init() {}
    

    
    func saveUserInfo(uid: String, nickname: String, birthday: String, gender: String, income: String, location: String) {
        
        // 저장할 데이터 정의
        let userData: [String: Any] = [
            "nickname": nickname,
            "birthday": birthday,
            "gender": gender,
            "income": income,
            "location": location,
            "email": Auth.auth().currentUser?.email ?? "" // 이메일도 같이 저장 가능
        ]
        
        //                self.userSession = user // 가입하면 바로 로그인 되도록 세션 등록
        
        // users 컬렉션에 UID를 키로 데이터 저장
        let db = Firestore.firestore()
        db.collection("users").document(uid).setData(userData) { error in
            if let error = error {
                print("Error saving user data: \(error.localizedDescription)")
            } else {
                print("User data saved successfully!")
            }
        }
    }
    
    // 사용자 가입정보 저장
    func saveUserData(uid: String, userData: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        Firestore.firestore().collection("users").document(uid).setData(userData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    
    
    //MARK: - 파이어베이스 회원정보 읽기
    
    func fetchUserData(uid: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        Firestore.firestore().collection("users").document(uid).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists {
                completion(.success(document.data() ?? [:]))
            } else {
                completion(.success([:]))
            }
        }
    }
    
    func updateUserData(uid: String, data: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        Firestore.firestore().collection("users").document(uid).updateData(data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func deleteUserData(uid: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Firestore.firestore().collection("users").document(uid).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
