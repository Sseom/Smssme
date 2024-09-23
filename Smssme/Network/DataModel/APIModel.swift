//
//  APIModel.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/14/24.
//

import Foundation

//MARK: - 주요 경제지수 통합모델

// 공통 프로토콜
protocol FinancialData {
    var name: String { get }   // 지수명
}

//MARK: - 코스피 데이터 모델
//공공데이터포털 - 금융위원회 API를 사용합니다.

struct KOSPIResponse: Codable, FinancialData {
    let response: Response
    var name: String = "KOSPI"
}

struct Response: Codable {
    let body: Body
}

struct Body: Codable {
    let items: Items
}

struct Items: Codable {
    let item: [KOSPIItem]
}

struct KOSPIItem: Codable {
    let basDt: String // 기준 일자
    let idxNm: String // 지수명
    let idxCsf: String // 지수 구분
//    let epyItmsCnt: String // 종목 수
    let clpr: String // 종가
    let vs: String // 전일 대비 등락
    let fltRt: String // 등락률
    let mkp: String // 시가
//    let hipr: String // 최고가
//    let lopr: String // 최저가
//    let trqu: String // 거래량
//    let trPrc: String // 거래대금
//    let lstgMrktTotAmt: String // 상장시가총액
//    let lsYrEdVsFltRg: String // 전년 말 대비 등락폭
//    let lsYrEdVsFltRt: String // 전년 말 대비 등락률
//    let yrWRcrdHgst: String // 연중 최고가
//    let yrWRcrdHgstDt: String // 연중 최고가 날짜
//    let yrWRcrdLwst: String // 연중 최저가
//    let yrWRcrdLwstDt: String // 연중 최저가 날짜
//    let basPntm: String // 기준 시점
//    let basIdx: String // 기준 지수
}


//MARK: -환율 데이터 모델
//한국수출입은행 API를 사용합니다.

struct ExchangeRate: Codable, FinancialData {
    var name: String = "환율"
    let curCode: String? //통화 코드 (예: USD)
    let bkpr: String? // 은행 매매 기준율
    
    //    let dealBasR: String //매매 기준율
    //    let dealSpd: String //매매 거래율
    //    let ycdt: String //기준일
    //    let curNm: String //통화명
    
    enum CodingKeys: String, CodingKey {
        case curCode = "cur_unit"
        case bkpr = "bkpr"
        
        //        case dealBasR = "deal_bas_r"
        //        case dealSpd = "deal_spd"
        //        case dealBss = "deal_bss"
        //        case ycdt = "ycdt"
        //        case curNm = "cur_nm"
    }
}

//MARK: -S&P500 데이터 모델
//FRED API를 사용합니다.
struct SP500Response: Codable, FinancialData {
    var name: String = "S&P500"
    let observations: [Observation] // 관측 데이터 배열
}

struct Observation: Codable {
    let date: String      // 관측 날짜
    let value: String     // S&P 500 값
}
