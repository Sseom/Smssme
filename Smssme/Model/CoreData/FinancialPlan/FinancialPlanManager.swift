//
//  FinancialPlanManager.swift
//  Smssme
//
//  Created by 임혜정 on 9/4/24.
//

import CoreData
import Foundation

// MARK: - crud 담당
class FinancialPlanManager {
    static let shared = FinancialPlanManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Smssme")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // Create
    func createFinancialPlan(id: String, title: String, amount: Int64, deposit: Int64, startDate: Date, endDate: Date, planType: Int16, customTitle: String?, isCompleted: Bool) -> FinancialPlan {
        let plan = FinancialPlan(context: context)
        plan.id = id
        plan.key = UUID()
        plan.title = title
        plan.amount = amount
        plan.deposit = deposit
        plan.startDate = startDate
        plan.endDate = endDate
        plan.planType = planType
        plan.customTitle = customTitle
        plan.isCompleted = isCompleted
        
        saveContext()
        return plan
    }
    
    //read
    func fetchAllFinancialPlans() -> [FinancialPlan] {
        let fetchRequest: NSFetchRequest<FinancialPlan> = FinancialPlan.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("\(error)")
            return []
        }
    }
    
    func fetchFinancialPlan(withId id: String) -> FinancialPlan? {
        let fetchRequest: NSFetchRequest<FinancialPlan> = FinancialPlan.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Error fetching financial plan: \(error)")
            return nil
        }
    }
    
    //update
    func updateFinancialPlan(withId id: String, title: String, amount: Int64, deposit: Int64, startDate: Date, endDate: Date, planType: Int16, isCompleted: Bool) throws {
        let fetchRequest: NSFetchRequest<FinancialPlan> = FinancialPlan.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let plans = try context.fetch(fetchRequest)
            guard let plan = plans.first else {
                throw NSError(domain: "FinancialPlanManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "플랜을 찾을 수 없음"])
            }
            
            plan.title = title
            plan.amount = amount
            plan.deposit = deposit
            plan.startDate = startDate
            plan.endDate = endDate
            plan.planType = planType
            plan.isCompleted = isCompleted
            
            try context.save()
        } catch {
            throw error
        }
    }
    
    //delete
    func deleteFinancialPlan(_ plan: FinancialPlan) {
        context.delete(plan)
        saveContext()
    }
    
}

