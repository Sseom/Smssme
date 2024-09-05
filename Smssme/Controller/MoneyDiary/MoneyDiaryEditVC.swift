//
//  MoneyDiaryEditVC.swift
//  Smssme
//
//  Created by 전성진 on 8/30/24.
//

import UIKit

class MoneyDiaryEditVC: UIViewController {
    var transactionItem: TransactionItemEdit
    var transactionItem2: Diary
    //MARK: - Properties
    private let moneyDiaryEditView: MoneyDiaryEditView = MoneyDiaryEditView()
    
    // MARK: - ViewController Init
    init(transactionItem2: Diary) {
        self.transactionItem = TransactionItemEdit()
        self.transactionItem2 = transactionItem2
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addTarget()
        configureUI()
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
        moneyDiaryEditView.saveButton.addTarget(self, action: #selector(updateData), for: .touchUpInside)
        moneyDiaryEditView.cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        
    }
    
    private func configureUI() {
        moneyDiaryEditView.priceTextField.text = String(transactionItem2.amount)
        moneyDiaryEditView.datePicker.date = transactionItem2.date ?? Date()
        moneyDiaryEditView.titleTextField.text = transactionItem2.title
        moneyDiaryEditView.categoryTextField.text = transactionItem2.category
        moneyDiaryEditView.noteTextField.text = transactionItem2.note
        
        
        
        
    }
    
    @objc func updateData() {
        let date = moneyDiaryEditView.datePicker.date
        let amount = Int64(moneyDiaryEditView.priceTextField.text ?? "0") ?? 0
        let statement =
        if moneyDiaryEditView.segmentControl.selectedSegmentIndex == 0 {
            false
        }
        else { true }
        let titleTextField = moneyDiaryEditView.titleTextField.text ?? ""
        let categoryTextField = moneyDiaryEditView.categoryTextField.text ?? ""
        let memo = moneyDiaryEditView.noteTextField.text ?? ""
        let uuid = transactionItem2.key!
        
        DiaryCoreDataManager.shared.updateDiary(with: uuid,
                                                newTitle: titleTextField,
                                                newDate: date,
                                                newAmount: amount,
                                                newStatement: statement,
                                                newCategory: categoryTextField,
                                                newNote: memo,
                                                newUserId: "userKim")
        
        self.navigationController?.popViewController(animated: false)
        print(self.transactionItem)
    }
    
    
    
    
    
    
    
    
    
    
//    @objc func saveData() {
//        let date = moneyDiaryEditView.datePicker.date
//        let amount = Int64(moneyDiaryEditView.priceTextField.text ?? "0") ?? 0
//        let statement =
//        if moneyDiaryEditView.segmentControl.selectedSegmentIndex == 0 {
//            false
//        }
//        else { true }
//        let titleTextField = moneyDiaryEditView.titleTextField.text ?? ""
//        let categoryTextField = moneyDiaryEditView.categoryTextField.text ?? ""
//        let memo = moneyDiaryEditView.noteTextField.text ?? ""
//        
//        
//        
//        
//        DiaryCoreDataManager.shared.createDiary(title: titleTextField, date: date, amount: amount, statement: statement, category: categoryTextField, note: memo, userId: "userKim")
//        
//        self.navigationController?.popViewController(animated: false)
//        print(self.transactionItem)
//    }
    @objc func didTapCancelButton() {
        self.navigationController?.popViewController(animated: false)
    }
}


