//
//  AssetsCoreDataManager.swift
//  Smssme
//
//  Created by 전성진 on 8/30/24.
//

import Foundation
import CoreData
import UIKit

class FinancialPlanManager {
    static let shared = FinancialPlanManager()
    
    private let context: NSManagedObjectContext
    
    private init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
    }
    
    func createFinancialPlan(title: String, startDate: Date, endDate: Date, amount: Int64, deposit: Int64) throws -> FinancialPlan {
        let plan = FinancialPlan(context: context)
        plan.id = UUID().uuidString
        plan.title = title
        plan.startDate = startDate
        plan.endDate = endDate
        plan.amount = amount
        plan.deposit = deposit
        
       
        try context.save()
        return plan
    }
    
    func fetchFinancialPlans() -> [FinancialPlan] {
        let request: NSFetchRequest<FinancialPlan> = FinancialPlan.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch financial plans: \(error)")
            return []
        }
    }
    
    func updateFinancialPlan(_ plan: FinancialPlan) throws {
        
        try context.save()
    }
    
    func deleteFinancialPlan(_ plan: FinancialPlan) throws {
        context.delete(plan)
        try context.save()
    }
    

}

extension FinancialPlanManager {
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
    
    func validateDates(start: Date?, end: Date?) throws {
        guard let start = start, let end = end, start < end else {
            throw ValidationError.invalidDateRange
        }
    }
}

enum ValidationError: Error {
    case emptyTitle
    case negativeAmount
    case negativeDeposit
    case invalidDateRange
}
