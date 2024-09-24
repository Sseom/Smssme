//
//  APIModel.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/14/24.
//

import Foundation

//MARK: - MainPageView에 사용될 주요 경제지수 통합모델
struct StockIndexData {
    let indexName: String  // 지수명
    let indexValue: String // 지수 값 (종가, 환율 값 등)
    let changeRate: String? // 전일 대비 등락률
    let changePoint: String? // 전일 대비 등락 포인트
    
    // KOSPI 데이터를 StockIndexData로 변환
    static func convertKOSPIToStockIndex(kospiItem: KOSPIItem) -> StockIndexData {
        return StockIndexData(
            indexName: kospiItem.idxNm,
            indexValue: kospiItem.clpr,
            changeRate: kospiItem.fltRt,
            changePoint: kospiItem.vs
        )
    }

    // 환율 데이터를 StockIndexData로 변환
    static func convertExchangeRateToStockIndex(exchangeRate: ExchangeRate) -> StockIndexData {
        return StockIndexData(
            indexName: "환율",
            indexValue: exchangeRate.bkpr ?? "N/A",
            changeRate: "N/A",
            changePoint: "N/A"
        )
    }

    // S&P 500 데이터를 StockIndexData로 변환
    static func convertSP500OToStockIndex(value: String, changeRate: String, changePoint: String) -> StockIndexData {
        return StockIndexData(
            indexName: "S&P 500",
            indexValue: value,
            changeRate: "N/A",
            changePoint: "N/A"
        )
    }
}

//MARK: - 코스피 데이터 모델
//공공데이터포털 - 금융위원회 API를 사용합니다.
struct KOSPIResponse: Codable {
    let response: Response
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
}


//MARK: -환율 데이터 모델
//한국수출입은행 API를 사용합니다.

struct ExchangeRate: Codable {
    let curCode: String? //통화 코드 (예: USD)
    let bkpr: String? // 은행 매매 기준율
    
    enum CodingKeys: String, CodingKey {
        case curCode = "cur_unit"
        case bkpr = "bkpr"
    }
}

//MARK: -S&P500 데이터 모델
//FRED API를 사용합니다.
struct SP500Response: Codable {
    let observations: [Observation] // 관측 데이터 배열
}

struct Observation: Codable {
    let date: String      // 관측 날짜
    let value: String     // S&P 500 값
}



