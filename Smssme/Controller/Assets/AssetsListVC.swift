//
//  AssetsEditVC.swift
//  Smssme
//
//  Created by 전성진 on 9/2/24.
//

import UIKit

class AssetsListVC: UIViewController {
    //MARK: - Properties
    private let assetsListView: AssetsListView = AssetsListView()
    private let assetsCoreDataManager: AssetsCoreDataManager = AssetsCoreDataManager()
    
    var uuid: UUID?
    
    // MARK: - ViewController Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        self.view = assetsListView
        self.navigationItem.title = "나의 자산편집"
        setButtonEvents()
        setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - Method
    
    // MARK: - Private Method
    private func setButtonEvents() {
    }
    
    private func setDeleteButton() {
    }
    
    private func setData() {
//        if let uuid = uuid, let asset = assetsCoreDataManager.selectSelectAssets(uuid: uuid).first {
//            assetsListView.categoryTextField.text = asset.category
//            assetsListView.titleTextField.text = asset.title
//            assetsListView.amountTextField.text = "\(KoreanCurrencyFormatter.shared.string(from: asset.amount))"
//            assetsListView.noteTextField.textColor = .black
//            assetsListView.noteTextField.text = asset.note
//            setDeleteButton()
//        }
    }
    
    private func saveAssets() {
//        let assets = AssetsItem(
//            category: assetsListView.categoryTextField.text,
//            title: assetsListView.titleTextField.text, 
//            amount: KoreanCurrencyFormatter.shared.number(from: assetsListView.amountTextField.text ?? "") ?? 0,
//            note: assetsListView.noteTextField.text
//        )
//        
//        if let uuid = uuid {
//            assetsCoreDataManager.updateAssets(assetsItem: assets, uuid: uuid)
//        } else {
//            assetsCoreDataManager.createAssets(assets: assets)
//        }
    }
    
    private func deleteAssets() {
//        if let uuid = uuid {
//            assetsCoreDataManager.deleteAssets(uuid: uuid)
//        } else {
//            print("유효한 자산이 아닙니다.")
//        }
    }
    
    // 뒤로가기전에 차트를 다시 그려주는 메서드
    private func popupViewController() {
//        if let mainPageVC = navigationController?.viewControllers.last(where: { $0 is MainPageVC }) as? MainPageVC {
//            
//            mainPageVC.setChartData()
//            
//            navigationController?.popViewController(animated: true)
//        } else {
//            // MainPageVC가 네비게이션 스택에 없는 경우 처리
//            print("MainPageVC를 찾을 수 없습니다.")
//        }
    }

    
    // MARK: - Objc
    @objc func saveButtonTapped() {
        saveAssets()
        popupViewController()
    }
    @objc func cancelButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    @objc func deleteButtonTapped() {
        deleteAssets()
        popupViewController()
    }
}
