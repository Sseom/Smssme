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
        setButtonEvents()
    }
    
    override func loadView() {
        super.loadView()
        self.view = assetsEditView
        self.navigationItem.title = "나의 자산편집"
    }
    
    // MARK: - Method
    
    // MARK: - Private Method
    private func setButtonEvents() {
        assetsEditView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        assetsEditView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
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
        
        assetsCoreDataManager.saveAssets(assets: assets)
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
}
