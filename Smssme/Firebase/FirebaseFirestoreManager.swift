//
//  FirebaseFirestoreManager.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/2/24.
//

import FirebaseFirestore
import FirebaseAuth

/// Firestore 데이터베이스와 관련된 CRUD(생성, 읽기, 업데이트, 삭제) 작업을 관리합니다.
final class FirebaseFirestoreManager {
    static let shared = FirebaseFirestoreManager()
     
    private init() {}
    

    //MARK: - 사용자 가입정보 저장
    func saveUserData(uid: String, userData: UserData, completion: @escaping (Result<Void, Error>) -> Void) {
        Firestore.firestore().collection("users").document(uid).setData(userData.toDictionary()) { error in
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
    
    //MARK: - 회원정보 수정
    func updateUserData(uid: String, data: UserData, completion: @escaping (Result<Void, Error>) -> Void) {
        Firestore.firestore().collection("users").document(uid).updateData(data.toDictionary()) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    
//    func deleteUserData(uid: String, completion: @escaping (Result<Void, Error>) -> Void) {
//        Firestore.firestore().collection("users").document(uid).delete { error in
//            if let error = error {
//                completion(.failure(error))
//            } else {
//                completion(.success(()))
//            }
//        }
//    }
}
