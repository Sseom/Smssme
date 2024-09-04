//
//  AssetsCoreDataManager.swift
//  Smssme
//
//  Created by 전성진 on 8/30/24.
//

import Foundation
import CoreData

class DiaryCoreDataManager {
    static let shared = DiaryCoreDataManager()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "YourModelName")
        container.loadPersistentStores { _, error in
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
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func createDiary(title: String, date: Date, amount: Int64, statement: Bool, category: String?, note: String?, userId: String?) {
        let context = DiaryCoreDataManager.shared.context
        let newDiary = Diary(context: context)
        
        newDiary.key = UUID()
        newDiary.date = date
        newDiary.amount = amount
        newDiary.statement = statement
        newDiary.category = category
        newDiary.note = note
        newDiary.title = title
        newDiary.userId = userId
        
        DiaryCoreDataManager.shared.saveContext()
    }
    func fetchDiaries() -> [Diary]? {
        let context = DiaryCoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<Diary> = Diary.fetchRequest()
        
        do {
            let diaries = try context.fetch(fetchRequest)
            return diaries
        } catch {
            print("Failed to fetch diaries: \(error)")
            return nil
        }
    }
    
    func fetchDiary(with key: UUID) -> Diary? {
        let context = DiaryCoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<Diary> = Diary.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "key == %@", key as CVarArg)
        
        do {
            let diaries = try context.fetch(fetchRequest)
            return diaries.first
        } catch {
            print("Failed to fetch diary: \(error)")
            return nil
        }
    }
    
    func updateDiary(with key: UUID, newTitle: String?, newDate: Date?, newAmount: Int64?, newStatement: Bool?, newCategory: String?, newNote: String?, newUserId: String?) {
        let context = DiaryCoreDataManager.shared.context
        
        if let diaryToUpdate = fetchDiary(with: key) {
            if let newTitle = newTitle {
                diaryToUpdate.title = newTitle
            }
            if let newDate = newDate {
                diaryToUpdate.date = newDate
            }
            if let newAmount = newAmount {
                diaryToUpdate.amount = newAmount
            }
            if let newStatement = newStatement {
                diaryToUpdate.statement = newStatement
            }
            if let newCategory = newCategory {
                diaryToUpdate.category = newCategory
            }
            if let newNote = newNote {
                diaryToUpdate.note = newNote
            }
            if let newUserId = newUserId {
                diaryToUpdate.userId = newUserId
            }
            
            DiaryCoreDataManager.shared.saveContext()
        }
    }
    
    func deleteDiary(with key: UUID) {
        let context = DiaryCoreDataManager.shared.context
        
        if let diaryToDelete = fetchDiary(with: key) {
            context.delete(diaryToDelete)
            DiaryCoreDataManager.shared.saveContext()
        }
    }
}
