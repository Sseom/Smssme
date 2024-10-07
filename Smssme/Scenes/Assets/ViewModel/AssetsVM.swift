//
//  AssetsVM.swift
//  Smssme
//
//  Created by 전성진 on 10/7/24.
//

import Foundation

import RxSwift

class AssetsVM {
    private let assetsService = AssetsService()
    private let disposeBag = DisposeBag()
    
    let assetsSubject = PublishSubject<Assets>()
    
    func getAssets(uuid: UUID) {
        assetsService.getAssets(uuid: uuid)
            .subscribe(
                onNext: { assets in
                    self.assetsSubject.onNext(assets)
                }, onError: { error in
                    self.assetsSubject.onError(error)
                }
            ).disposed(by: disposeBag)
    }
    
    func createAssets(assetsItem: AssetsItem) -> Completable {
        return assetsService.createAssets(assetsItem: assetsItem)
    }
    
    func updateAssets(assetsItem: AssetsItem, uuid: UUID) -> Completable {
        assetsService.updateAssets(assetsItem: assetsItem, uuid: uuid)
    }
    
    func deleteAssets(uuid: UUID) -> Completable {
        assetsService.deleteAssets(uuid: uuid)
    }

}

enum AssetsError: Error {
  case nilData
}

