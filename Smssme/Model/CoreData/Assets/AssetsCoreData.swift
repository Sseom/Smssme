//
//  Assets+CoreDataClass.swift
//  Smssme
//
//  Created by 전성진 on 8/30/24.
//
//

import Foundation
import CoreData

@objc(Assets)
public class Assets: NSManagedObject {

}

extension Assets {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Assets> {
        return NSFetchRequest<Assets>(entityName: "Assets")
    }

    @NSManaged public var key: UUID?
    @NSManaged public var category: String?
    @NSManaged public var title: String?
    @NSManaged public var amount: Int64
    @NSManaged public var note: String?
    @NSManaged public var id: String?
    @NSManaged public var user: User?

}

extension Assets: Identifiable {

}

// 차트 공용메서드를 위한 프로토콜
extension Assets: ChartDataConvertible {}
