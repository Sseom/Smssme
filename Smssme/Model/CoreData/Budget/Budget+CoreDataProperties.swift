//
//  Budget+CoreDataProperties.swift
//  Smssme
//
//  Created by 전성진 on 8/30/24.
//
//

import Foundation
import CoreData


extension Budget {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Budget> {
        return NSFetchRequest<Budget>(entityName: "Budget")
    }

    @NSManaged public var key: UUID?
    @NSManaged public var amount: Int64
    @NSManaged public var statement: Bool
    @NSManaged public var category: String?
    @NSManaged public var date: Date?
    @NSManaged public var userId: String?

}

extension Budget : Identifiable {

}
