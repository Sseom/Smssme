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
    
    //MARK: - 이메일 인증
    // 현재 로그인한 사용자의 정보가 인자로 전달되어야 한다. 즉, 회원가입 된 사용자들에게만 이메일 인증 요청 가능...
    func sendEmailVerification() {
        auth.currentUser?.sendEmailVerification(completion: { [weak self] error in
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
            if let error = error {
                print("비밀번호 재설정 메일 발송을 실패했습니다.:\n \(error.localizedDescription)")
                completion(error)
                return
            }
            print("비밀번호 재설정 메일 발송을 성공했습니다. ")
            completion(nil)
        }
    }
    
    // 비밀번호 재설정 코드와 새 비밀번호를 사용하여 비밀번호를 업데이트
    func confirmPasswordReset(code: String, newPassword: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().confirmPasswordReset(withCode: code, newPassword: newPassword) { error in
            if let error = error {
                print("Error confirming password reset: \(error.localizedDescription)")
                completion(error)
                return
            }
            print("Password has been reset successfully!")
            completion(nil)
        }
    }
    
    //MARK: - 로그인
    
    
    //MARK: - 로그아웃
    
    
    //MARK: - 회원탈퇴
    
    

}
