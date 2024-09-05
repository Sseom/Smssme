//
//  AssetsCoreDataManager.swift
//  Smssme
//
//  Created by 전성진 on 8/30/24.
//

import CoreData
import Foundation

class FinancialPlanRepository {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = FinancialPlanManager.shared.context) {
        self.context = context
    }
    
    func isPlanTitleExists(_ title: String) -> Bool {
            let fetchRequest: NSFetchRequest<FinancialPlan> = FinancialPlan.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "title == %@", title)
            
            do {
                let count = try context.count(for: fetchRequest)
                return count > 0
            } catch {
                return false
            }
        }
    func createFinancialPlan(title: String, amount: Int64, deposit: Int64, startDate: Date, endDate: Date) -> FinancialPlan {
        
        print("Attempting to create a new Financial Plan")
        print("Title: \(title)")
        print("Amount: \(amount)")
        print("Deposit: \(deposit)")
        print("Start Date: \(startDate)")
        print("End Date: \(endDate)")
        
        let plan = FinancialPlan(context: context)
        plan.id = UUID().uuidString
        plan.key = UUID()
        plan.title = title
        plan.amount = amount
        plan.deposit = deposit
        plan.startDate = startDate
        plan.endDate = endDate
        
        do {
            try context.save()
            print("Context saved successfully")
            return plan
        } catch {
            print("Failed to save context: \(error)")
            return plan
        }
    }
    
    func getAllFinancialPlans() -> [FinancialPlan] {
        let fetchRequest: NSFetchRequest<FinancialPlan> = FinancialPlan.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "endDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    func getFinancialPlan(byId id: String) -> FinancialPlan? {
        let fetchRequest: NSFetchRequest<FinancialPlan> = FinancialPlan.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Failed to fetch financial plan: \(error)")
            return nil
        }
    }
    
    func updateFinancialPlan(_ plan: FinancialPlan) {
        FinancialPlanManager.shared.saveContext()
    }
    
    func deleteFinancialPlan(_ plan: FinancialPlan) {
        context.delete(plan)
        FinancialPlanManager.shared.saveContext()
    }
    
}


// 저장된 데이터 확인
extension FinancialPlanRepository {
    func printAllFinancialPlans() {
        let plans = getAllFinancialPlans()
        print("Total number of Financial Plans: \(plans.count)")
        
        for (index, plan) in plans.enumerated() {
            print("Plan \(index + 1):")
            print("  ID: \(plan.id)")
            print("  UUID: \(plan.key?.uuidString ?? "N/A")")
            print("  Title: \(plan.title ?? "N/A")")
            print("  Amount: \(plan.amount)")
            print("  Deposit: \(plan.deposit)")
            print("  Start Date: \(plan.startDate?.description ?? "N/A")")
            print("  End Date: \(plan.endDate?.description ?? "N/A")")
            print("--------------------")
        }
    }
    
    func printFinancialPlan(withId id: String) {
        guard let plan = getFinancialPlan(byId: id) else {
            print("No Financial Plan found with ID: \(id)")
            return
        }
        
        print("Financial Plan Details:")
        print("  ID: \(plan.id)")
        print("  UUID: \(plan.key?.uuidString ?? "N/A")")
        print("  Title: \(plan.title ?? "N/A")")
        print("  Amount: \(plan.amount)")
        print("  Deposit: \(plan.deposit)")
        print("  Start Date: \(plan.startDate?.description ?? "N/A")")
        print("  End Date: \(plan.endDate?.description ?? "N/A")")
    }
}
