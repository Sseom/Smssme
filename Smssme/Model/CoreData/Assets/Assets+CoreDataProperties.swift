//
//  Assets+CoreDataProperties.swift
//  Smssme
//
//  Created by 전성진 on 8/30/24.
//
//

import Foundation
import CoreData


extension Assets {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Assets> {
        return NSFetchRequest<Assets>(entityName: "Assets")
    }

    @NSManaged public var key: UUID?
    @NSManaged public var category: String?
    @NSManaged public var title: String?
    @NSManaged public var amount: Int64
    @NSManaged public var note: String?
    @NSManaged public var userId: String?

}

extension Assets : Identifiable {

}
