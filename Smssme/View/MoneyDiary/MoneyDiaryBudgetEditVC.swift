//
//  MoneyDiaryEditVC.swift
//  Smssme
//
//  Created by 전성진 on 8/30/24.
//

import UIKit

class MoneyDiaryBudgetEditVC: UIViewController {
    // MARK: - Properties
    private let moneyDiaryBudgetEditView: MoneyDiaryBudgetEditView = MoneyDiaryBudgetEditView()
    private let budgetCoreDataManager: BudgetCoreDataManager = BudgetCoreDataManager()
    // 더미 데이터
    var dummyList: [BudgetList] = []
    
    // MARK: - ViewController Init
    init() {
        super.init(nibName: nil, bundle: nil)
        setupList()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        moneyDiaryBudgetEditView.tableView.dataSource = self
        moneyDiaryBudgetEditView.tableView.delegate = self
        moneyDiaryBudgetEditView.tableView.register(MoneyDiaryBudgetEditCell.self, forCellReuseIdentifier: "MoneyDiaryBudgetEditCell")
        moneyDiaryBudgetEditView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AssetPlanCell")
        let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonTapped))
                navigationItem.rightBarButtonItem = saveButton
    }
    
    override func loadView() {
        super.loadView()
        self.view = moneyDiaryBudgetEditView
    }
    
    // MARK: - Method
    
    func setSectionAmount(forSection section: Int) -> String {
        let total = dummyList[section].items.reduce(0) { sum, item in
            return sum + Int(item.amount)
        }
        return "\(total) 원"
    }
    
    func setTotalAmount() -> String {
        var total: Int64 = 0
        
        for listIndex in 0..<dummyList.count {
            for item in dummyList[listIndex].items {
                if item.statement {
                    total += item.amount
                } else {
                    total -= item.amount
                }
            }
        }
        
        return "\(total) 원"
    }
    
    func addNewItem(toSection section: Int) {
        let item = BudgetItem(amount: 0, statement: true, category: "", isAssetPlan: section == 0 ? true : false)
        dummyList[section].items.append(item)
        let indexPath = IndexPath(row: dummyList[section].items.count - 1, section: section)
        moneyDiaryBudgetEditView.tableView.insertRows(at: [indexPath], with: .none)
    }
    
    // MARK: - Private Method
    private func setupList() {
        dummyList = [
            BudgetList(title: "수입 플랜", items: [
                BudgetItem(amount: 2300000, statement: true, category: "월급", isAssetPlan: false),
                BudgetItem(amount: 500000, statement: true, category: "보너스", isAssetPlan: false)
            ]),
            BudgetList(title: "나의 자산 플랜", items: [
                BudgetItem(amount: 500000, statement: false, category: "웨딩플랜", isAssetPlan: false),
                BudgetItem(amount: 900000, statement: false, category: "내차 마련", isAssetPlan: false)
            ]),
            BudgetList(title: "소비 플랜", items: [
                BudgetItem(amount: 500000, statement: false, category: "겨울옷", isAssetPlan: false),
                BudgetItem(amount: 30000, statement: false, category: "교통비", isAssetPlan: false)
            ])
        ]
    }
    
    private func getBudgetItems() -> [BudgetItem] {
        var budgetItems: [BudgetItem] = []
        
        for section in 0..<dummyList.count {
            if section != 1 {
                for row in 0..<dummyList[section].items.count {
                    let indexPath = IndexPath(row: row, section: section)
                    if let cell = moneyDiaryBudgetEditView.tableView.cellForRow(at: indexPath) as? MoneyDiaryBudgetEditCell {
                        let category = cell.categoryTextField.text ?? ""
                        let amountText = cell.amountTextField.text ?? ""
                        let amount = Int64(amountText) ?? 0
                        
                        let item = dummyList[section].items[row]
                        let budgetItem = BudgetItem(amount: amount, statement: item.statement, category: category, isAssetPlan: item.isAssetPlan)
                        budgetItems.append(budgetItem)
                    }
                }
            }
        }
        
        return budgetItems
    }
    
    // MARK: - Objc
    @objc private func deleteButtonTapped(_ sender: UIButton) {
        let section = sender.tag / 1000
        let row = sender.tag % 1000
        
        guard section < dummyList.count, row < dummyList[section].items.count else {
            print("잘못된 인덱스 접근: section \(section), row \(row)")
            return
        }
        
        print(row)
        
        dummyList[section].items.remove(at: row)
        moneyDiaryBudgetEditView.tableView.deleteRows(at: [IndexPath(row: row, section: section)], with: .none)
        moneyDiaryBudgetEditView.tableView.reloadData()
    }
    
    @objc private func saveButtonTapped() {
        let budgetItems = getBudgetItems()
        print("Collected Data: \(budgetItems)")
        budgetCoreDataManager.deleteAllBudget()
        budgetCoreDataManager.saveBudget(budgetList: budgetItems)
        
        print("전체 저장 성공")
        
        budgetCoreDataManager.selectAllBudget().forEach {
            print("금액: \($0.amount)")
            print("상태: \($0.statement)")
            print("카테고리: \($0.category ?? "에러")")
        }
    }
}

// MARK: - UITableViewDataSource
extension MoneyDiaryBudgetEditVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dummyList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return dummyList[section].items.count
        }
        return dummyList[section].items.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let list = dummyList[indexPath.section]
        
        if indexPath.row < list.items.count {
            let item = list.items[indexPath.row]
            
            if indexPath.section == 1 {
                // 섹션 1은 수정 불가능하도록 UILabel을 사용
                let cell = tableView.dequeueReusableCell(withIdentifier: "AssetPlanCell", for: indexPath)
                cell.textLabel?.text = "\(item.category): \(item.amount) 원"
                cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
                cell.textLabel?.textColor = .black
                return cell
            } else {
                // 다른 섹션은 수정 가능하도록 UITextField를 사용
                let cell = tableView.dequeueReusableCell(withIdentifier: "MoneyDiaryBudgetEditCell", for: indexPath) as! MoneyDiaryBudgetEditCell
                cell.categoryTextField.text = item.category
                cell.amountTextField.text = "\(item.amount)"
                
                cell.amountTextField.delegate = self
                
                cell.categoryTextField.tag = indexPath.section * 1000 + indexPath.row
                cell.amountTextField.tag = indexPath.section * 1000 + indexPath.row + 100
                
                cell.deleteButton.tag = indexPath.section * 1000 + indexPath.row
                cell.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
                
                return cell
            }
        } else {
            let addCell = UITableViewCell(style: .default, reuseIdentifier: "addCell")
            addCell.textLabel?.text = "항목 추가하기"
            addCell.textLabel?.textColor = .systemBlue
            addCell.textLabel?.textAlignment = .center
            return addCell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == dummyList[indexPath.section].items.count {
            addNewItem(toSection: indexPath.section)
        }
    }
}

// MARK: - UITableViewDelegate
extension MoneyDiaryBudgetEditVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerText = "\(dummyList[section].title) - 총 금액: \(setSectionAmount(forSection: section))"
        moneyDiaryBudgetEditView.totalView.label.text = "잉여금액 - 총 금액: \(setTotalAmount())"
        
        let headerView = MoneyDiaryBudgetEditHeaderView(section: section, text: headerText)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}

extension MoneyDiaryBudgetEditVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        // section과 row 계산
        let section = textField.tag / 1000
        let row = textField.tag % 1000
        
        // 카테고리 또는 금액 업데이트
        if row < 100 { // 카테고리 필드
            print(row)
            dummyList[section].items[row].category = textField.text ?? ""
        } else { // 금액 필드
            print(row)
            let amountText = textField.text ?? "0"
            let amount = Int64(amountText) ?? 0
            dummyList[section].items[row - 100].amount = amount
        }
        
        // 합계 재계산 및 업데이트
        moneyDiaryBudgetEditView.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
}
