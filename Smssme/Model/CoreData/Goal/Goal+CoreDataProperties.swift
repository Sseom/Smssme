//
//  Goal+CoreDataProperties.swift
//  Smssme
//
//  Created by 전성진 on 8/30/24.
//
//

import Foundation
import CoreData

extension FinancialPlan {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FinancialPlan> {
        return NSFetchRequest<FinancialPlan>(entityName: FinancialPlan.entityName)
    }

    @NSManaged public var id: String
    @NSManaged public var key: UUID?
    @NSManaged public var title: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var endDate: Date?
    @NSManaged public var amount: Int64
    @NSManaged public var deposit: Int64
    @NSManaged public var user: User?

    public enum Key: String {
        case id, key, title, startDate, endDate, amount, deposit, user
    }
}


struct PlanItem {
    let title: String
    let description: String
    let imageName: String
    var isPreset: Bool
    var uuid: UUID?
}

class PlanItemStore {
    static let shared = PlanItemStore()
    
    private init() {}
    
    var planItems: [PlanItem] = []
    
    let presetPlans: [PlanItem] = [
        PlanItem(title: "잊지못할 인생여행", description: "꿈꿔왔던 그곳을 가기위한 나의 인생여행 자금 마련 플랜", imageName: "trip2", isPreset: true),
        PlanItem(title: "드림카 프로젝트", description: "나만의 드림카를 갖는 그날을 위한 드림카플랜", imageName: "trip2", isPreset: true),
        PlanItem(title: "내집 마련의 꿈", description: "미래의 나의 보금자리를 위한 첫걸음, 내집마련 플랜", imageName: "trip", isPreset: true),
        PlanItem(title: "로맨틱 결혼식", description: "새로운 삶의 시작인 그 행복한 순간을 위한 결혼자금 플랜", imageName: "trip", isPreset: true),
        PlanItem(title: "황금빛 은퇴자금", description: "편안한 은퇴를 위한 준비, 빨리 시작할수록 든든합니다!", imageName: "trip", isPreset: true)
    ]
    
    func loadInitialData() {
        planItems = presetPlans
    }
    
    func addCustomPlan(_ plan: PlanItem) {
        planItems.append(plan)
    }
    
    func getPlanAt(index: Int) -> PlanItem? {
        guard index < planItems.count else { return nil }
        return planItems[index]
    }
    
    func getAllPlans() -> [PlanItem] {
        return planItems
    }
    
    func getPlansCount() -> Int {
        return planItems.count
    }
}

extension PlanItemStore {
    func getTotalItemCount() -> Int {
        return presetPlans.count + planItems.count
    }
    
    func getPresetPlansCount() -> Int {
        return presetPlans.count
    }
    
    func getPresetPlanAt(index: Int) -> PlanItem? {
        guard index < presetPlans.count else { return nil }
        return presetPlans[index]
    }
    
    func getCustomPlanAt(index: Int) -> PlanItem? {
        guard index < planItems.count else { return nil }
        return planItems[index]
    }
}
