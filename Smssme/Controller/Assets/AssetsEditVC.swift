//
//  AssetsEditVC.swift
//  Smssme
//
//  Created by 전성진 on 9/2/24.
//

import UIKit

class AssetsEditVC: UIViewController {
    //MARK: - Properties
    private let assetsEditView: AssetsEditView = AssetsEditView()
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
        self.view = assetsEditView
        self.navigationItem.title = "나의 자산편집"
        setButtonEvents()
        setData()
    }
    
    // MARK: - Method
    
    // MARK: - Private Method
    private func setButtonEvents() {
        assetsEditView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        assetsEditView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    private func setDeleteButton() {
        assetsEditView.deleteButton.target = self
        assetsEditView.deleteButton.action = #selector(deleteButtonTapped)
        navigationItem.rightBarButtonItem = assetsEditView.deleteButton
    }
    
    private func setData() {
        if let uuid = uuid, let asset = assetsCoreDataManager.selectSelectAssets(uuid: uuid).first {
            assetsEditView.categoryTextField.text = asset.category
            assetsEditView.titleTextField.text = asset.title
            assetsEditView.amountTextField.text = "\(asset.amount)"
            assetsEditView.noteTextField.textColor = .black
            assetsEditView.noteTextField.text = asset.note
            setDeleteButton()
        }
    }
    
    private func saveAssets() {
        let amountText = assetsEditView.amountTextField.text ?? ""
        let amount = Int64(amountText) ?? 0
        let assets = AssetsItem(
            category: assetsEditView.categoryTextField.text,
            title: assetsEditView.titleTextField.text, 
            amount: amount,
            note: assetsEditView.noteTextField.text
        )
        
        if let uuid = uuid {
            assetsCoreDataManager.updateAssets(assetsItem: assets, uuid: uuid)
        } else {
            assetsCoreDataManager.createAssets(assets: assets)
        }
    }
    
    private func deleteAssets() {
        if let uuid = uuid {
            assetsCoreDataManager.deleteAssets(uuid: uuid)
        } else {
            print("유효한 자산이 아닙니다.")
        }
    }

    
    // MARK: - Objc
    @objc func saveButtonTapped() {
        saveAssets()
        // 일단 여기서 해주지 말고 mainPageVC 에서 viewWillAppear 에 넣어줌
//        let mainPageVC = MainPageVC()
//        mainPageVC.setChartData()
        navigationController?.popViewController(animated: true)
    }
    @objc func cancelButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    @objc func deleteButtonTapped() {
        deleteAssets()
        // 일단 여기서 해주지 말고 mainPageVC 에서 viewWillAppear 에 넣어줌
//        let mainPageVC = MainPageVC()
//        mainPageVC.setChartData()
        navigationController?.popViewController(animated: true)
    }
}

//extension AssetsEditVC: KeyboardEvader {
//    var keyboardScrollView: UIScrollView {
//        <#code#>
//    }
//    
//}
