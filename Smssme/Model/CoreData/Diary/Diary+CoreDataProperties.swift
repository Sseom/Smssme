//
//  Diary+CoreDataProperties.swift
//  Smssme
//
//  Created by 전성진 on 8/30/24.
//
//

import Foundation
import CoreData


extension Diary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diary> {
        return NSFetchRequest<Diary>(entityName: "Diary")
    }

    @NSManaged public var key: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var amount: Int64
    @NSManaged public var statement: Bool
    @NSManaged public var category: String?
    @NSManaged public var note: String?
    @NSManaged public var title: String?
    @NSManaged public var userId: String?

}

extension Diary : Identifiable {

}
