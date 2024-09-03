//
//  FirebaseManager.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/2/24.
//

import Firebase

/// Firebase의 공통적인 초기화 및 공통 기능을 관리합니다.
/// Firebase와 관련된 초기화 작업을 하며, 다른 Firebase 기능 클래스들을 호출할 수 있는 역할을 합니다.
final class FirebaseManager {
    static let shared = FirebaseManager()

    
    private init() {
        FirebaseApp.configure()
    }

    func configureFirebase() {
        // Firebase 초기화 및 공통 설정을 여기에 추가
        FirebaseApp.configure()
    }
}

