//
//  AssetsService.swift
//  Smssme
//
//  Created by 전성진 on 10/7/24.
//

import Foundation
import RxSwift

class AssetsService {
    private let assetsCoreDataManager = AssetsCoreDataManager()
    
    func getAssets(uuid: UUID) -> Observable<Assets> {
        return Observable.create { observer in
            let assets = self.assetsCoreDataManager.selectSelectAssets(uuid: uuid).first
            
            if let assets = assets {
                observer.onNext(assets)
                observer.onCompleted()
            } else {
                observer.onError(AssetsError.nilData)
            }
            
            return Disposables.create()
        }
    }
    
    func createAssets(assetsItem: AssetsItem) -> Completable {
        return Completable.create { completable in // Completable 작업 완료 상태를 방출하는 객체
            self.assetsCoreDataManager.createAssets(assetsItem: assetsItem)
            completable(.completed)
            return Disposables.create()
        }
    }
    
    func updateAssets(assetsItem: AssetsItem, uuid: UUID) -> Completable {
        return Completable.create { completable in
            self.assetsCoreDataManager.updateAssets(assetsItem: assetsItem, uuid: uuid)
            completable(.completed)
            return Disposables.create()
        }
    }
    
    func deleteAssets(uuid: UUID) -> Completable {
        return Completable.create { completable in
            self.assetsCoreDataManager.deleteAssets(uuid: uuid)
            completable(.completed)
            return Disposables.create()
        }
    }
}
