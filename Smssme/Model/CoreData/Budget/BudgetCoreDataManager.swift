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
