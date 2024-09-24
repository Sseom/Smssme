//
//  AssetsCoreDataManager.swift
//  Smssme
//
//  Created by 전성진 on 8/30/24.
//

import CoreData
import UIKit

class BudgetCoreDataManager {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // 예산안 저장
    func saveBudget(budgetList: [BudgetItem]) {
        budgetList.forEach {
            let budget = Budget(context: context)
            budget.id = nil
            budget.date = $0.date
            budget.amount = $0.amount
            budget.category = $0.category
            budget.statement = $0.statement
            budget.key = UUID()
            do {
                try context.save()
                print("저장 성공")
            } catch {
                print("에러: \(error.localizedDescription)")
            }

        }
    }
    
    // 예산안 가져오기
    func selectAllBudget() -> [Budget] {
        let fetchRequest: NSFetchRequest<Budget> = Budget.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let budget = try context.fetch(fetchRequest)
            return budget
        } catch {
            print("에러: \(error.localizedDescription)")
            return []
        }
    }
    
    // 월별 예산안 가져오기
    func selectMonthBudget(from startDate: Date, to endDate: Date) -> [Budget] {
        let fetchRequest: NSFetchRequest<Budget> = Budget.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date <= %@", startDate as CVarArg, endDate as CVarArg)
        do {
            let budget = try context.fetch(fetchRequest)
            return budget
        } catch {
            print("에러: \(error.localizedDescription)")
            return []
        }
    }
    
    func deleteMonthBudget(from startDate: Date, to endDate: Date){
        let fetchRequest = Budget.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date <= %@", startDate as CVarArg, endDate as CVarArg)
        do{
            let result = try self.context.fetch(fetchRequest)
            for data in result as [NSManagedObject]{
                self.context.delete(data)
            }
            try self.context.save()
            print("삭제 성공")
        }catch{
            print("삭제 실패")
        }
    }
    
    func deleteAllBudget(){
        let fetchRequest = Budget.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "wordsBookId == %@", wordsBookId as CVarArg)
        do{
            let result = try self.context.fetch(fetchRequest)
            for data in result as [NSManagedObject]{
                self.context.delete(data)
            }
            try self.context.save()
            print("삭제 성공")
        }catch{
            print("삭제 실패")
        }
    }
}

class BudgetService {
    // 플랜에 따른 이번 달에 모아야 하는 금액 구하기
    func calculateSavings(plan: FinancialPlanDTO, startDate: Date?, endDate: Date?, amount: Int64) -> Int64 {
        guard let start = startDate,
              let end = endDate else {
            return 0
        }
        
        let calendar = Calendar.current
        let now = Date()
        
        // 현재 날짜가 계획 기간 밖이면 0 반환
        guard now >= start && now <= end else {
            return 0
        }
        
        let totalDays = calendar.dateComponents([.day], from: start, to: end).day! + 1
        let dailyAmount = Double(amount) / Double(totalDays)
        
        // 이번 달의 시작과 끝 날짜 계산
        let currentMonthStart = calendar.dateInterval(of: .month, for: now)!.start
        let currentMonthEnd = min(calendar.dateInterval(of: .month, for: now)!.end - 1, end)
        
        // 이번 달의 일 수 계산
        let daysInCurrentMonth = calendar.dateComponents([.day], from: max(currentMonthStart, start), to: currentMonthEnd).day! + 1
        
        // 이번 달의 저축액 계산
        let savingsForCurrentMonth = (dailyAmount * Double(daysInCurrentMonth) - Double(plan.deposit))
        
        return max(0, Int64(round(savingsForCurrentMonth)))
//        return Int64(round(savingsForCurrentMonth))
    }
}
