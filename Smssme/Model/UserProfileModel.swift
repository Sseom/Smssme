//
//  UserProfile.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/11/24.
//

import Foundation

struct UserData {
    var email: String?
    var password: String?
    var nickname: String?
    var birth: String?
    var gender: String?
    var income: String?
    var location: String?
    
    // Firebase에 저장할 데이터로 변환
    func toDictionary() -> [String: Any] {
        return [
            "email": email ?? "",
            "password": password ?? "",
            "nickname": nickname ?? "",
            "birth": birth ?? "",
            "gender": gender ?? "",
            "income": income ?? "",
            "location": location ?? ""
        ]
    }
}
