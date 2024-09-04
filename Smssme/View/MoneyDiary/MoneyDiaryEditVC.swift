//
//  MoneyDiaryEditVC.swift
//  Smssme
//
//  Created by 전성진 on 8/30/24.
//

import UIKit

class MoneyDiaryEditVC: UIViewController {
    var transactionItem: TransactionItemEdit
    
    //MARK: - Properties
    private let moneyDiaryEditView: MoneyDiaryEditView = MoneyDiaryEditView()
    
    // MARK: - ViewController Init
    init() {
        self.transactionItem = TransactionItemEdit()
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addTarget()
    }
    
    override func loadView() {
        super.loadView()
        self.view = moneyDiaryEditView
    }
    
    // MARK: - Method
    
    // MARK: - Private Method
    //    private func setupSegmentEvent() {
    //        moneyDiaryEditView
    //    }
    
    //MARK: - Objc
    func addTarget() {
        moneyDiaryEditView.saveButton.addTarget(self, action: #selector(saveData), for: .touchUpInside)
        moneyDiaryEditView.cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        
    }
    @objc func saveData() {
        self.transactionItem.date = moneyDiaryEditView.datePicker.date
        self.transactionItem.amount = Int(moneyDiaryEditView.priceTextField.text ?? "0") ?? 0
        
        self.transactionItem.statement =
        if moneyDiaryEditView.segmentControl.selectedSegmentIndex == 0 {
            false
        }
        else { true }
        
        self.transactionItem.title = moneyDiaryEditView.titleTextField.text ?? ""
        
        self.transactionItem.category = moneyDiaryEditView.categoryTextField.text ?? ""
        self.transactionItem.memo = moneyDiaryEditView.noteTextField.text ?? ""
        
        self.navigationController?.popViewController(animated: false)
        print(self.transactionItem)
    }
    @objc func didTapCancelButton() {
        self.navigationController?.popViewController(animated: false)
    }
}


