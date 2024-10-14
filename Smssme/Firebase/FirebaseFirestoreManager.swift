//
//  FirebaseFirestoreManager.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/2/24.
//

import FirebaseFirestore
import FirebaseAuth
import CoreData

/// Firestore 데이터베이스와 관련된 CRUD(생성, 읽기, 업데이트, 삭제) 작업을 관리합니다.
final class FirebaseFirestoreManager {
    static let shared = FirebaseFirestoreManager()
     
    private init() {}
    
    //MARK: - Create
    // 모든 사용자 가입정보 저장
    func saveUserData(uid: String, userData: UserData, completion: @escaping (Result<Void, Error>) -> Void) {
        Firestore.firestore().collection("users").document(uid).setData(userData.toDictionary()) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    //MARK: - Read
    // 모든 회원정보 읽기
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
    
    // 특정 필드의 회원 정보 읽기
    func fetchUserField(uid: String, field: String, completion: @escaping (Result<Any, Error>) -> Void) {
        Firestore.firestore().collection("users").document(uid).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists {
                if let fieldValue = document.get(field) {  // 특정 필드의 값만 가져오기
                    completion(.success(fieldValue))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Field not found"])))
                }
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"])))
            }
        }
    }
    
    //MARK: - Update
    // 모든 회원정보 수정
    func updateUserData(uid: String, data: UserData, completion: @escaping (Result<Void, Error>) -> Void) {
        Firestore.firestore().collection("users").document(uid).updateData(data.toDictionary()) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // 특정 필드만 업데이트
    func updateUserField(uid: String, field: String, value: Any, completion: @escaping (Result<Void, Error>) -> Void) {
        let data: [String: Any] = [field: value]
        
        Firestore.firestore().collection("users").document(uid).updateData(data) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    //MARK: - Delete
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



//임시, 플랜>서버

extension FirebaseFirestoreManager {
    func saveFinancialPlan(plan: FinancialPlan, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "FirebaseFirestoreManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
            return
        }
        
        guard let keyString = plan.key?.uuidString else {
            completion(.failure(NSError(domain: "FirebaseFirestoreManager", code: -2, userInfo: [NSLocalizedDescriptionKey: "Invalid plan key"])))
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users").document(userId).collection("financialPlans").document(keyString).setData(plan.toFirestoreData()) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func fetchFinancialPlans(completion: @escaping (Result<[FinancialPlan], Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "FirebaseFirestoreManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users").document(userId).collection("financialPlans").getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            let context = FinancialPlanManager.shared.context
            let plans = querySnapshot?.documents.compactMap { document -> FinancialPlan? in
                let data = document.data()
                let plan = FinancialPlan(context: context)
                
                if let keyString = data["key"] as? String {
                    plan.key = UUID(uuidString: keyString)
                }
                plan.title = data["title"] as? String
                plan.startDate = (data["startDate"] as? Timestamp)?.dateValue()
                plan.endDate = (data["endDate"] as? Timestamp)?.dateValue()
                plan.amount = data["amount"] as? Int64 ?? 0
                plan.deposit = data["deposit"] as? Int64 ?? 0
                plan.planType = data["planType"] as? Int16 ?? 0
                plan.isCompleted = data["isCompleted"] as? Bool ?? false
                plan.completionDate = (data["completionDate"] as? Timestamp)?.dateValue()
                
                return plan
            } ?? []
            
            completion(.success(plans))
        }
    }
    
    func syncFinancialPlansToCoreData(completion: @escaping (Result<Void, Error>) -> Void) {
        fetchFinancialPlans { result in
            switch result {
            case .success(let plans):
                let context = FinancialPlanManager.shared.context
                context.perform {
                    // 기존 데이터 삭제 
                    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = FinancialPlan.fetchRequest()
                    let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                    _ = try? context.execute(batchDeleteRequest)
                    
                    do {
                        try context.save()
                        completion(.success(()))
                    } catch {
                        completion(.failure(error))
                    }
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}

