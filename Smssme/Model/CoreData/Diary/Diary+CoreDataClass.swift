//
//  Diary+CoreDataClass.swift
//  Smssme
//
//  Created by 전성진 on 8/30/24.
//
//

import Foundation
import CoreData

@objc(Diary)
public class Diary: NSManagedObject, Identifiable {
    public static let entityName = "Diary"
}
