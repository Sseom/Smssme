//
//  User+CoreDataProperties.swift
//  Smssme
//
//  Created by 전성진 on 8/30/24.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: String?
    @NSManaged public var password: String?
    @NSManaged public var gender: String?
    @NSManaged public var birth: Date?
    @NSManaged public var income: String?
    @NSManaged public var nickname: String?
    @NSManaged public var region: String?
    @NSManaged public var email: String?

}

extension User : Identifiable {

}
