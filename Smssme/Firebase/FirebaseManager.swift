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
    
    //MARK: - 이메일 인증
    func sendEmailVerification() {
        auth.currentUser?.sendEmailVerification(completion: { error in
            if let error = error {
                print("이메일 인증 오류: \(error.localizedDescription)")
            } else {
                print("이메일 인증 전송 완료")
            }
        })
    }
    
    //MARK: - 비밀번호 찾기
    func resetPassword(email: String, completion: @escaping (Error?) -> Void) {
        auth.sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
    
    //MARK: - 로그인
    
    
    //MARK: - 로그아웃
    
    
    //MARK: - 회원탈퇴
    
    

}
