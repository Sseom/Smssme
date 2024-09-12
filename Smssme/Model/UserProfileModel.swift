//
//  UserProfile.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/11/24.
//

import Foundation

struct UserData {
    var email: String
    var password: String
    var nickname: String
    var birth: String
    var gender: String
    var income: String
    var location: String
    
    func toDictionary() -> [String: Any] {
        return [
            "email": email,
            "nickname": nickname,
            "birth": birth,
            "gender": "선택안함",
            "income": income,
            "location": location
        ]
    }
}
