//
//  AutomaticTransactionVC.swift
//  Smssme
//
//  Created by KimRin on 9/12/24.
//코드검토 (2024.09.15)// 정규표현식 이해의 대한 어려움
//어떻게 풀어서 쓸것이며 어떻게 더 정확히 값을 뽑아낼수있을까 
//11

import UIKit
import SnapKit
import RxSwift

class AutomaticTransactionVC: UIViewController {
    private let automaticView = AutomaticTransactionView()
    
    private let viewModel = AutomaticTransactionVM()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        observeState()
        
    }
    
    func setupUI() {
        
        [
            automaticView
        ].forEach { view.addSubview($0) }
        //사용방법 버튼 구성?
        self.automaticView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        automaticView.submitButton.addTarget(self, action: #selector(saveData), for: .touchUpInside)
        
    }
    
    private func observeState() {
        viewModel.event
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { state in
                    
                    switch state {
                        
                    case .onSaveComplete(let completeTitle, let completeMessage):
                        self.showAlert(title: completeTitle, message: completeMessage, isComplete: true)
                    case .onSaveFail(let errorTitle, let errorMessage):
                        self.showAlert(title: errorTitle, message: errorMessage)
                    }
                }
            ).disposed(by: disposeBag)
    }
    
    //alert은 동일하게 띄우지만 text 값이 다름, 재사용성
    func showAlert(title: String, message: String, isComplete: Bool = false) {
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            if isComplete {
                
                self.dismiss(animated: true)
            }
        }
        
        alertController.addAction(okAction)
        
        alertController.title = title
        alertController.message = message
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    @objc func saveData() {
        let text = automaticView.inputTextView.text
        viewModel.onAction(action: AutomaticTransactionAction.onsave(text))
    }
    
}


