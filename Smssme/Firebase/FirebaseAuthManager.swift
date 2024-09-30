//
//  FirebaseManager.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/11/24.
//


import AuthenticationServices
import CryptoKit
import FirebaseAuth
import FirebaseFirestore


class FirebaseAuthManager: NSObject, ASAuthorizationControllerDelegate {
    static let shared = FirebaseAuthManager()
    
    let auth: Auth
    let db: Firestore
    
    private override init() {
        self.auth = Auth.auth()
        self.db = Firestore.firestore()
    }
    
    //MARK: - 이메일 로그인
    // 회원가입
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
    
    // 이메일 중복 확인
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
    
    // 이메일 인증 메일 전송
    func sendEmailVerification(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            print("No user is logged in.")
            return
        }
        
        user.sendEmailVerification { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // 비밀번호 재설정 메일 전송
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
    
    // 재인증
    func reauthenticateUser(email: String, password: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let user = auth.currentUser else {
            completion(.failure(AuthError.userNotFound))
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password ?? "")
        
        // 파이어베이스 재인증 메서드
        user.reauthenticate(with: credential) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
            
        }
    }
    
    // 이메일 수정
    func updateEmail(newEmail: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        guard let currentEmail = Auth.auth().currentUser?.email else {
            completion(false, AuthError.userNotFound)
            return
        }
        //        reauthenticateUser(email: Auth.auth().currentUser?.email ?? "", password: password) { result in
        //            switch result {
        //            case .success:
        //                Auth.auth().currentUser?.updateEmail(to: newEmail) { error in
        //                    completion(error == nil, error)
        //                }
        
        reauthenticateUser(email: currentEmail, password: password) { result in
            switch result {
            case .success:
                Auth.auth().currentUser?.updateEmail(to: newEmail) { error in
                    if let error = error {
                        completion(false, error)
                    } else {
                        completion(true, nil)
                    }
                }
            case .failure(let error):
                completion(false, error)
            }
        }
    }
    
    
    // 로그인
    func login(withEmail email: String, password: String, completion: @escaping (Result<Void, AuthErrorCode>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError? {
                // 에러 코드에 따라 결과 반환
                if let authErrorCode = AuthErrorCode(rawValue: error.code) {
                    completion(.failure(authErrorCode))
                } else {
                    completion(.failure(.operationNotAllowed)) // 기본 에러 처리
                }
                return
            }
            
            // 성공적으로 로그인된 경우
            completion(.success(()))
        }
    }
    
    // 로그아웃
    
    
    // 회원탈퇴
    func deleteUser(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        guard let currentEmail = Auth.auth().currentUser?.email else {
            completion(false, AuthError.userNotFound)
            return
        }
        
        // 재인증 후 회원탈퇴 처리
        if email == currentEmail {
            // 이메일이 같을 경우 재인증 후 회원탈퇴 처리
            reauthenticateUser(email: currentEmail, password: password) { result in
                switch result {
                case .success:
                    // 재인증 성공 후 계정 삭제
                    Auth.auth().currentUser?.delete { error in
                        if let error = error {
                            completion(false, error)  // 삭제 실패
                        } else {
                            completion(true, nil)     // 삭제 성공
                        }
                    }
                case .failure(let error):
                    // 재인증 실패
                    completion(false, error)
                }
            }
        } else {
            // 이메일이 다를 경우 처리
            completion(false, NSError(domain: "Email mismatch", code: 401, userInfo: [NSLocalizedDescriptionKey: "The entered email does not match the current user's email."]))
            print("입력하신 이메일과 현재 로그인 된 이메일이 다릅니다.")
        }
    }
    
    
    //MARK: - Apple 로그인
    // 보안 강화를 위해서 생성하는 Nonce
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    // 애플로그인에서 nonce는 일반 텍스트로 사용되지 않고 SHA256로 변환해서 애플에 전송
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    // Apple Sign-In 및 Firebase 인증 처리
    func signInWithApple(credential: ASAuthorizationAppleIDCredential, nonce: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        guard let appleIDToken = credential.identityToken,
              let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            completion(.failure(NSError(domain: "Apple Sign In", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to fetch identity token"])))
            return
        }
        
        // Nonce 검증
        let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com",
                                                          idToken: idTokenString,
                                                          rawNonce: nonce)
        
        // Firebase에 로그인
        Auth.auth().signIn(with: firebaseCredential) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let authResult = authResult {
                completion(.success(authResult))
            }
        }
    }
    
}


enum AuthError: LocalizedError {
    case userNotFound
    case invalidCredentials
    
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "사용자를 찾을 수 없습니다."
        case .invalidCredentials:
            return "입력한 인증 정보가 올바르지 않습니다."
        }
    }
}


