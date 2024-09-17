//
//  APIModel.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/14/24.
//

import Foundation

//MARK: -S&P500 데이터 모델
//FRED API를 사용합니다.
struct SP500Response: Codable {
    let observations: [Observation] // 관측 데이터 배열
}

struct Observation: Codable {
    let date: String      // 관측 날짜
    let value: String     // S&P 500 값
}
