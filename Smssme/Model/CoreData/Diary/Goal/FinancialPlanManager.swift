//
//  FinancialPlanManager.swift
//  Smssme
//
//  Created by 임혜정 on 9/4/24.
//

import CoreData
import Foundation

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
}
//유효성검사로직
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
