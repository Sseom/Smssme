//
//  Goal+CoreDataClass.swift
//  Smssme
//
//  Created by 전성진 on 8/30/24.
//
//

import Foundation
import CoreData

@objc(FinancialPlan)
public class FinancialPlan: NSManagedObject, Identifiable {
    public static let entityName = "FinancialPlan"
}
