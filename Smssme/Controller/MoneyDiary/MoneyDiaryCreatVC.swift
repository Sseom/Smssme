//
//  MoneyDiaryCreatVC.swift
//  Smssme
//
//  Created by KimRin on 9/5/24.
//
import UIKit


class MoneyDiaryCreatVC: UIViewController {
    
//    var transactionItem2: Diary
    //MARK: - Properties
    private let moneyDiaryCreateView: MoneyDiaryCreateView = MoneyDiaryCreateView()
    
    // MARK: - ViewController Init
    init() {
        
//        self.transactionItem2 = transactionItem2
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
        self.view = moneyDiaryCreateView
    }
    
    // MARK: - Method
    
    // MARK: - Private Method
    //    private func setupSegmentEvent() {
    //        moneyDiaryEditView
    //    }
    
    //MARK: - Objc
    func addTarget() {
        moneyDiaryCreateView.saveButton.addTarget(self, action: #selector(saveData), for: .touchUpInside)
        moneyDiaryCreateView.cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        
    }
    
    private func configureUI() {
//        moneyDiaryEditView.priceTextField.text = String(transactionItem2.amount)
//        moneyDiaryEditView.datePicker.date = transactionItem2.date ?? Date()
//        moneyDiaryEditView.titleTextField.text = transactionItem2.title
//        moneyDiaryEditView.categoryTextField.text = transactionItem2.category
//        moneyDiaryEditView.noteTextField.text = transactionItem2.note
        
        
        
        
    }
    
//    @objc func updateData() {
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
//        let uuid = transactionItem2.key!
//        
//        DiaryCoreDataManager.shared.updateDiary(with: uuid,
//                                                newTitle: titleTextField,
//                                                newDate: date,
//                                                newAmount: amount,
//                                                newStatement: statement,
//                                                newCategory: categoryTextField,
//                                                newNote: memo,
//                                                newUserId: "userKim")
//        
//        self.navigationController?.popViewController(animated: false)
//        
//    }
    
    
    
    
    
    
    
    
    
    
    @objc func saveData() {
        let date = moneyDiaryCreateView.datePicker.date
        let amount = Int64(moneyDiaryCreateView.priceTextField.text ?? "0") ?? 0
        let statement =
        if moneyDiaryCreateView.segmentControl.selectedSegmentIndex == 0 {
            false
        }
        else { true }
        let titleTextField = moneyDiaryCreateView.titleTextField.text ?? ""
        let categoryTextField = moneyDiaryCreateView.categoryTextField.text ?? ""
        let memo = moneyDiaryCreateView.noteTextField.text ?? ""
        DiaryCoreDataManager.shared.createDiary(title: titleTextField, date: date, amount: amount, statement: statement, category: categoryTextField, note: memo, userId: "userKim")

        self.navigationController?.popViewController(animated: false)
        
    }
    @objc func didTapCancelButton() {
        self.navigationController?.popViewController(animated: false)
    }
}
