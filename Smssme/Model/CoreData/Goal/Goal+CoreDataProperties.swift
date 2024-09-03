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
