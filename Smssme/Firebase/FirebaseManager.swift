//
//  FirebaseManager.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/11/24.
//

import FirebaseAuth
import FirebaseFirestore

class FirebaseManager {
    static let shared = FirebaseManager()
    
    let auth: Auth
    let db: Firestore
    
    private init() {
        self.auth = Auth.auth()
        self.db = Firestore.firestore()
    }
    
    //MARK: - 회원가입
    func registerUser(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let uid = authResult?.user.uid else {
                let error = NSError(domain: "Firebase", code: -1, userInfo: [NSLocalizedDescriptionKey: "UID 생성 실패"])
                completion(.failure(error))
                return
            }
            
            completion(.success(uid))
        }
    }
    
    //MARK: - 이메일 중복 확인
    func checkEmail(email: String, completion: @escaping (Bool) -> Void) {
        db.collection("users").whereField("email", isEqualTo: email).getDocuments { (querySnapshot, error) in
            if let error = error { //nil이 아닐 경우 아래 구문 실행 -> 에러가 있다.
                print("이메일 존재 확인 여부 오류: \n \(error.localizedDescription)")
                completion(false)
                return
            }
            
            if let documents = querySnapshot?.documents, !documents.isEmpty {
                completion(true) // 이미 존재하는 이메일
            } else {
                completion(false)
            }
        }
    }
    
    //MARK: - 이메일 인증 메일 전송
    func sendEmailVerification(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            print("No user is logged in.")
            return
        }
        
        user.sendEmailVerification { error in
            if let error = error {
                completion(.failure(error)) // 실패 시 에러를 반환
            } else {
                completion(.success(())) // 성공 시 빈 값 반환
            }
        }
    }
    
    //MARK: - 비밀번호 재설정 메일 전송
    func sendPasswordResetEmail(email: String, completion: @escaping (Error?) -> Void) {
        auth.sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("비밀번호 재설정 메일 발송을 실패했습니다.:\n \(error.localizedDescription)")
                completion(error)
                return
            }
            print("비밀번호 재설정 메일 발송을 성공했습니다. ")
            completion(nil)
        }
    }
    
    //MARK: - 이메일 수정
    
    
    //MARK: - 로그인
    
    
    //MARK: - 로그아웃
    
    
    //MARK: - 회원탈퇴
    
    
    
}
