//
//  AssetsCoreDataManager.swift
//  Smssme
//
//  Created by 전성진 on 8/30/24.
//

import CoreData
import UIKit

class AssetsCoreDataManager {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // 신규 자산 저장
    func createAssets(assets: AssetsItem) {
        let newAssets = Assets(context: context)
        newAssets.id = nil
        newAssets.amount = assets.amount
        newAssets.category = assets.category
        newAssets.note = assets.note
        newAssets.title = assets.title
        newAssets.key = UUID()
        do {
            try context.save()
            print("저장 성공")
        } catch {
            print("에러: \(error.localizedDescription)")
        }
    }
    
    // 신규 자산 수정
    func updateAssets(assetsItem: AssetsItem, uuid: UUID) {
        let fetchRequest: NSFetchRequest<Assets> = Assets.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "key == %@", uuid as CVarArg)
        do {
            let result = try context.fetch(fetchRequest)
            if let assets = result.first {
                print(assets)
                assets.amount = assetsItem.amount
                assets.category = assetsItem.category
                assets.note = assetsItem.note
                assets.title = assetsItem.title
                try context.save()
                print("수정 성공")
            } else {
                print("유효하지 않은 자산")
            }
        } catch {
            print("에러: \(error.localizedDescription)")
        }
    }

    
    // 자산 전체 가져오기
    func selectAllAssets() -> [Assets] {
        let fetchRequest: NSFetchRequest<Assets> = Assets.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let assets = try context.fetch(fetchRequest)
            return assets
        } catch {
            print("에러: \(error.localizedDescription)")
            return []
        }
    }
    
    // 자산 하나 가져오기
    func selectSelectAssets(uuid: UUID) -> [Assets] {
        let fetchRequest: NSFetchRequest<Assets> = Assets.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "key == %@", uuid as CVarArg)
        do {
            let assets = try context.fetch(fetchRequest)
            return assets
        } catch {
            print("에러: \(error.localizedDescription)")
            return []
        }
    }
    
    
    func deleteAssets(uuid: UUID){
        let fetchRequest: NSFetchRequest<Assets> = Assets.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "key == %@", uuid as CVarArg)
        do{
            let result = try self.context.fetch(fetchRequest)
            for data in result as [NSManagedObject]{
                self.context.delete(data)
            }
            try self.context.save()
            print("삭제 성공")
        }catch{
            print("삭제 실패")
        }
    }

}
