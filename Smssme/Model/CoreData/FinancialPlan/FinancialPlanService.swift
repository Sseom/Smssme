//
//  FinancinalPlanService.swift
//  Smssme
//
//  Created by 임혜정 on 9/16/24.
//

import CoreData
import Foundation

// MARK: - 비즈니스 로직 담당
class FinancialPlanService {
    private let manager: FinancialPlanManager
    
    init(manager: FinancialPlanManager = .shared) {
        self.manager = manager
    }
    
    // MARK: - Create
    func createFinancialPlan(title: String, amount: Int64, deposit: Int64, startDate: Date, endDate: Date, planType: PlanType, isCompleted: Bool, completionDate: Date) throws -> FinancialPlanDTO {
        // 유효성 검사
        try validateAmount(amount)
        try validateDeposit(deposit)
        try validateDates(start: startDate, end: endDate)
        
        let id = UUID().uuidString
        let customTitle = planType == .custom ? title : nil
        
        // 플랜 생성
        let plan = manager.createFinancialPlan(
            id: id,
            title: title,
            amount: amount,
            deposit: deposit,
            startDate: startDate,
            endDate: endDate,
            planType: Int16(planType.rawValue),
            customTitle: customTitle,
            isCompleted: isCompleted,
            completionDate: completionDate
        )
        
        plan.planDescription = planType.planDescription
        plan.iconName = planType.iconName
        
        manager.saveContext()
        
        return convertToDTO(plan)
    }
    
    // MARK: - Read
    func fetchFinancialPlan(withId id: String) -> FinancialPlanDTO? {
        guard let plan = manager.fetchFinancialPlan(withId: id) else { return nil }
        return convertToDTO(plan)
    }
    
    func fetchAllFinancialPlans() -> [FinancialPlanDTO] {
        return manager.fetchAllFinancialPlans().map(convertToDTO)
    }
    
    func fetchFinancialPlans(forType planType: PlanType) -> [FinancialPlanDTO] {
        return manager.fetchAllFinancialPlans()
            .filter { $0.planType == Int16(planType.rawValue) }
            .map(convertToDTO)
    }
    
    // 완료되지 않은 플랜(진행중 플랜)
    func fetchIncompletedPlans() -> [FinancialPlanDTO] {
        return fetchAllFinancialPlans().filter { !$0.isCompleted }
    }
    
    // 완료된 플랜만 불러오기
    func fetchCompletedFinancialPlans() -> [FinancialPlanDTO] {
        return fetchAllFinancialPlans()
            .filter { $0.isCompleted }
            .sorted { $0.completionDate > $1.completionDate }
    }
    
    // MARK: - Update
    func updateFinancialPlan(_ dto: FinancialPlanDTO) throws {
        try validateAmount(dto.amount)
        try validateDeposit(dto.deposit)
        try validateDates(start: dto.startDate, end: dto.endDate)
        
        try manager.updateFinancialPlan(
            withId: dto.id,
            title: dto.title,
            amount: dto.amount,
            deposit: dto.deposit,
            startDate: dto.startDate,
            endDate: dto.endDate,
            planType: Int16(dto.planType.rawValue), 
            isCompleted: dto.isCompleted, 
            completionDate: dto.completionDate
        )
        
        if dto.planType == .custom {
            try updateCustomTitle(forPlanWithId: dto.id, newTitle: dto.title)
        }
    }
    
    func updateCustomTitle(forPlanWithId id: String, newTitle: String) throws {
        guard let plan = manager.fetchFinancialPlan(withId: id) else {
            throw NSError(domain: "FinancialPlanService", code: 404, userInfo: [NSLocalizedDescriptionKey: "플랜을 찾을 수 없음"])
        }
        
        if PlanType(rawValue: plan.planType) == .custom {
            try manager.updateFinancialPlan(
                withId: id,
                title: plan.title ?? "",
                amount: plan.amount,
                deposit: plan.deposit,
                startDate: plan.startDate ?? Date(),
                endDate: plan.endDate ?? Date(),
                planType: plan.planType,
                isCompleted: plan.isCompleted,
                completionDate: plan.completionDate ?? Date()
            )
        } else {
            throw NSError(domain: "FinancialPlanService", code: 400, userInfo: [NSLocalizedDescriptionKey: "커스텀 플랜만 제목을 변경할 수 있습니다."])
        }
    }
    
    // MARK: - Delete
    func deleteFinancialPlan(_ dto: FinancialPlanDTO) throws {
        guard let plan = manager.fetchFinancialPlan(withId: dto.id) else {
            throw NSError(domain: "FinancialPlanService", code: 404, userInfo: [NSLocalizedDescriptionKey: "플랜을 찾을 수 없음"])
        }
        manager.deleteFinancialPlan(plan)
    }
    //MARK: - 완료플랜 지우기
    func deleteIncompleteItems() {
        do {
            // 1. Fetch Request 생성
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FinancialPlan")
            fetchRequest.predicate = NSPredicate(format: "isCompleted == %@", NSNumber(value: true))
            
            // 2. 일괄 삭제 요청 생성
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            // 3. 일괄 삭제 실행
            try manager.executeDeleteRequest(batchDeleteRequest)
            
            print("Incomplete items deleted successfully")
        } catch {
            print("Failed to delete incomplete items: \(error)")
        }
    }
    
    // MARK: - 비즈니스로직
    func calculateTotalAmount() -> Int64 {
        return fetchAllFinancialPlans().reduce(0) { $0 + $1.amount }
    }
    
    func calculateTotalDeposit() -> Int64 {
        return fetchAllFinancialPlans().reduce(0) { $0 + $1.deposit }
    }
    
    func getRemainingAmount(for dto: FinancialPlanDTO) -> Int64 {
        return dto.amount - dto.deposit
    }
    
    func getProgressPercentage(for dto: FinancialPlanDTO) -> Double {
        guard dto.amount > 0 else { return 0 }
        return Double(dto.deposit) / Double(dto.amount) * 100
    }
    
    func getPlansEndingSoon(within days: Int = 30) -> [FinancialPlanDTO] {
        let currentDate = Date()
        let futureDate = Calendar.current.date(byAdding: .day, value: days, to: currentDate)!
        
        return fetchAllFinancialPlans().filter { dto in
            dto.endDate > currentDate && dto.endDate <= futureDate
        }
    }
    
    // MARK: - 유효성
    func validateAmount(_ amount: Int64) throws {
        guard amount > 0 else {
            throw ValidationError.negativeAmount
        }
    }
    
    func validateDeposit(_ deposit: Int64) throws {
        guard deposit >= 0 else {
            throw ValidationError.negativeDeposit
        }
    }
    
    func validateDates(start: Date, end: Date) throws {
        guard start < end else {
            throw ValidationError.invalidDateRange
        }
    }
    
    // MARK: - 선택창
    func isPlanTypeExists(_ planType: PlanType) -> Bool {
        let incompletePlans = fetchIncompletedPlans()
        let planTypes = Set(incompletePlans.map { PlanType(rawValue: $0.planType.rawValue) })
        return planTypes.contains(planType)
    }
    
    func getFinancialPlanByTitle(_ title: String) -> FinancialPlanDTO? {
        return fetchIncompletedPlans().first { $0.title == title }
    }
    
    // MARK: - 컨펌창/ 이번 달 모아야될 금액
    func calculateSavings(plan: FinancialPlanDTO, startDate: Date?, endDate: Date?, amount: Int64) -> Int64 {
        guard let start = startDate,
              let end = endDate else {
            return 0
        }
        
        let calendar = Calendar.current
        let now = Date()
        
        guard now >= start && now <= end else {
            return 0
        }
        
        let months = calendar.dateComponents([.month], from: start, to: end).month! + 1
        
        let monthlyAmount = Double(amount) / Double(months)
        
        let monthsPassed = calendar.dateComponents([.month], from: start, to: now).month!
        let shouldHaveSaved = monthlyAmount * Double(monthsPassed)
        
        let remainingForThisMonth = monthlyAmount - (Double(plan.deposit) - shouldHaveSaved)
        
        return max(0, Int64(round(remainingForThisMonth)))
    }

    // MARK: - 헬퍼 / dto변환
    private func convertToDTO(_ plan: FinancialPlan) -> FinancialPlanDTO {
        return FinancialPlanDTO(
            id: plan.id,
            title: plan.title ?? "",
            amount: plan.amount,
            deposit: plan.deposit,
            startDate: plan.startDate ?? Date(),
            endDate: plan.endDate ?? Date(),
            planType: PlanType(rawValue: plan.planType) ?? .custom,
            isCompleted: plan.isCompleted, 
            completionDate: plan.completionDate ?? Date()
        )
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
    var customTitle: String?
    var isCompleted: Bool
    var completionDate: Date
}

// MARK: - 유효성 검사 케이스

enum ValidationError: Error {
    case negativeAmount
    case negativeDeposit
    case invalidDateRange
    case depositExceedsAmount
}
