//
//  FinancialPlanData.swift
//  Smssme
//
//  Created by 임혜정 on 9/16/24.
//

import CoreData
import Foundation

@objc(FinancialPlan)


// MARK: - FinancialPlan은 데이터 모델 담당
public class FinancialPlan: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FinancialPlan> {
        return NSFetchRequest<FinancialPlan>(entityName: "FinancialPlan")
    }
    
    @NSManaged public var id: String
    @NSManaged public var key: UUID?
    @NSManaged public var title: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var endDate: Date?
    @NSManaged public var amount: Int64
    @NSManaged public var deposit: Int64
    @NSManaged public var planType: Int16
    @NSManaged public var customTitle: String?
    @NSManaged public var planDescription: String?
    @NSManaged public var iconName: String?
    
    @NSManaged public var user: User?
    
    public enum Key: String {
        case id, key, title, startDate, endDate, amount, deposit, user, planType, customTitle, planDescription, iconName
    }
}


// MARK: - 플랜 타입 정의, 프리셋타이틀을 제공하기 위함
enum PlanType: Int16, CaseIterable {
    case travel, car, house, wedding, retirement, custom
    
    var title: String {
        switch self {
        case .travel: return "잊지못할 인생여행"
        case .car: return "드림카 프로젝트"
        case .house: return "내집 마련의 꿈"
        case .wedding: return "로맨틱 결혼식"
        case .retirement: return "황금빛 은퇴자금"
        case .custom: return "나만의 플랜"
        }
    }
    
    var planDescription: String {
        switch self {
        case .travel: return "꿈꿔왔던 그곳을 가기위한 나의 인생여행 자금 마련 플랜"
        case .car: return "나만의 드림카를 갖는 그날을 위한 드림카플랜"
        case .house: return "미래의 나의 보금자리를 위한 첫걸음, 내집마련 플랜"
        case .wedding: return "새로운 삶의 시작인 그 행복한 순간을 위한 결혼자금 플랜"
        case .retirement: return "편안한 은퇴를 위한 준비, 빨리 시작할수록 든든합니다"
        case .custom: return "나만의 자산목표를 설정하고 체계적으로 이루어 보세요"
        }
    }
    
    var iconName: String {
        return "carIcon" // 선택창에서 아이콘을 사용하게될시 각 타입에 맞는 이미지 이름으로 변경
    }
}


// MARK: - dto

struct FinancialPlanDTO {
    var id: String
    var title: String
    var amount: Int64
    var deposit: Int64
    var startDate: Date
    var endDate: Date
    var planType: PlanType
}
