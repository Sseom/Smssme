//
//  AssetsEditVC.swift
//  Smssme
//
//  Created by 전성진 on 9/2/24.
//

import UIKit

import RxSwift

class AssetsEditVC: UIViewController {
    // MARK: - Properties
    private var assets: Assets?
    
    private let viewModel = AssetsVM()
    private let disposeBag = DisposeBag()
    
    // MARK: - View
    private let assetsEditView: AssetsEditView = AssetsEditView()
    
    // MARK: - ViewController Init
    init(uuid: UUID?) {
        super.init(nibName: nil, bundle: nil)
        if let uuid = uuid {
            subscribeAssets()
            viewModel.getAssets(uuid: uuid)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "나의 자산편집"
        self.view = assetsEditView
        setButtonEvents()
    }
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
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
    
    private func subscribeAssets() {
        viewModel.assetsSubject
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] assets in
                    print(assets)
                    self?.assets = assets
                    self?.configureAssets(assets: assets)
                }, onError: { error in
                    print("\(error)")
                }).disposed(by: disposeBag)
    }
    
    private func configureAssets(assets: Assets) {
        assetsEditView.categoryTextField.text = assets.category
        assetsEditView.titleTextField.text = assets.title
        assetsEditView.amountTextField.text = "\(KoreanCurrencyFormatter.shared.string(from: assets.amount))"
        assetsEditView.noteTextField.textColor = .black
        assetsEditView.noteTextField.text = assets.note
        setDeleteButton()
    }
    
    private func makeAssetsItem() -> AssetsItem {
        return AssetsItem(
            category: assetsEditView.categoryTextField.text,
            title: assetsEditView.titleTextField.text,
            amount: KoreanCurrencyFormatter.shared.number(from: assetsEditView.amountTextField.text ?? "") ?? 0,
            note: assetsEditView.noteTextField.text
        )
    }
    
    private func saveAssets() {
        let assetsItem = makeAssetsItem()
        
        if let assets = assets, let uuid = assets.key {
            viewModel.updateAssets(assetsItem: assetsItem, uuid: uuid)
                .observe(on: MainScheduler.instance)
                .subscribe(
                    onCompleted: { [weak self] in
                        self?.showSyncAlert(message: "수정이 완료되었습니다.", AlertTitle: "완료", buttonClickTitle: "확인") {
                            self?.navigationController?.popViewController(animated: true)
                        }
                    }
                ).disposed(by: disposeBag)
        } else {
            viewModel.createAssets(assetsItem: assetsItem)
                .observe(on: MainScheduler.instance)
                .subscribe(
                    onCompleted: { [weak self] in
                        self?.showSyncAlert(message: "생성이 완료되었습니다.", AlertTitle: "완료", buttonClickTitle: "확인") {
                            self?.navigationController?.popViewController(animated: true)
                        }
                    }
                ).disposed(by: disposeBag)
        }
    }
    
    private func deleteAssets() {
        if let assets = assets, let uuid = assets.key {
            viewModel.deleteAssets(uuid: uuid)
                .observe(on: MainScheduler.instance)
                .subscribe(
                    onCompleted: { [weak self] in
                        self?.showSyncAlert(message: "삭제 되었습니다.", AlertTitle: "삭제 완료", buttonClickTitle: "확인") {
                            self?.navigationController?.popViewController(animated: true)
                        }
                    }
                ).disposed(by: disposeBag)
        } else {
            showSyncAlert(message: "유효한 자산이 아닙니다.", AlertTitle: "알림", buttonClickTitle: "확인") {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // 뒤로가기전에 차트를 다시 그려주는 메서드
//    private func popupViewController() {
//        if let mainPageVC = navigationController?.viewControllers.last(where: { $0 is MainPageVC }) as? MainPageVC {
//            
//            mainPageVC.setChart()
//            
//            navigationController?.popViewController(animated: true)
//        } else {
//            // MainPageVC가 네비게이션 스택에 없는 경우 처리
//            print("MainPageVC를 찾을 수 없습니다.")
//        }
//    }
    
    // MARK: - Objc
    @objc func saveButtonTapped() {
        saveAssets()
    }
    @objc func cancelButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    @objc func deleteButtonTapped() {
        deleteAssets()
    }
}
