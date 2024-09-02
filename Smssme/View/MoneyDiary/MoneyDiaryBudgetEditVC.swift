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
        moneyDiaryBudgetEditView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AssetPlanCell") // 등록
        let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonTapped))
                navigationItem.rightBarButtonItem = saveButton
    }
    
    override func loadView() {
        super.loadView()
        self.view = moneyDiaryBudgetEditView
    }
    
    // MARK: - Method
    
    func calculateTotalAmount(forSection section: Int) -> String {
        let total = dummyList[section].items.reduce(0) { sum, item in
            return sum + Int(item.amount)
        }
        return "\(total) 원"
    }
    
    func addNewItem(toSection section: Int) {
        let item = BudgetItem(amount: 0, statement: true, category: "", isAssetPlan: section == 0 ? true : false)
        dummyList[section].items.append(item)
        let indexPath = IndexPath(row: dummyList[section].items.count - 1, section: section)
        moneyDiaryBudgetEditView.tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: - Private Method
    private func setupList() {
        dummyList = [
            BudgetList(title: "수입 플랜", items: [
                BudgetItem(amount: 500000, statement: true, category: "월급", isAssetPlan: false),
                BudgetItem(amount: 5000000, statement: true, category: "보너스", isAssetPlan: false)
            ]),
            BudgetList(title: "수입 플랜", items: [
                BudgetItem(amount: 500000, statement: true, category: "월급", isAssetPlan: false),
                BudgetItem(amount: 5000000, statement: true, category: "보너스", isAssetPlan: false)
            ]),
            BudgetList(title: "수입 플랜", items: [
                BudgetItem(amount: 500000, statement: true, category: "월급", isAssetPlan: false),
                BudgetItem(amount: 5000000, statement: true, category: "보너스", isAssetPlan: false)
            ])
        ]
    }
    
    private func collectDataFromTextFields() -> [BudgetList] {
        var collectedData: [BudgetList] = []
        
        for section in 0..<dummyList.count {
            if section != 1 {
                var budgetItems: [BudgetItem] = []
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
                
                let budgetList = BudgetList(title: dummyList[section].title, items: budgetItems)
                collectedData.append(budgetList)
            }
        }
        
        return collectedData
    }
    
    // MARK: - Objc
    @objc private func addButtonTapped(_ sender: UIButton) {
        let section = dummyList.count - 1
        addNewItem(toSection: section)
    }
    
    @objc private func deleteButtonTapped(_ sender: UIButton) {
        let section = sender.tag / 1000
        let row = sender.tag % 1000
        
        guard section < dummyList.count, row < dummyList[section].items.count else {
            print("잘못된 인덱스 접근: section \(section), row \(row)")
            return
        }
        
        dummyList[section].items.remove(at: row)
        moneyDiaryBudgetEditView.tableView.deleteRows(at: [IndexPath(row: row, section: section)], with: .automatic)
    }
    
    @objc private func saveButtonTapped() {
        let collectedData = collectDataFromTextFields()
        print("Collected Data: \(collectedData)")
        
        // 데이터 저장 로직 추가
//        saveDataToCoreData(data: collectedData)
    }
}

// MARK: - UITableViewDataSource
extension MoneyDiaryBudgetEditVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dummyList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let planTitle = dummyList[section].title
        let totalAmount = calculateTotalAmount(forSection: section)
        return "\(planTitle) - 총 금액: \(totalAmount)"
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
                cell.textLabel?.text = "\(item.category ?? ""): \(item.amount) 원"
                cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
                cell.textLabel?.textColor = .black
                return cell
            } else {
                // 다른 섹션은 수정 가능하도록 UITextField를 사용
                let cell = tableView.dequeueReusableCell(withIdentifier: "MoneyDiaryBudgetEditCell", for: indexPath) as! MoneyDiaryBudgetEditCell
                cell.categoryTextField.text = item.category
                cell.amountTextField.text = "\(item.amount)"
                
                cell.categoryTextField.tag = indexPath.section * 1000 + indexPath.row
                cell.amountTextField.tag = indexPath.section * 1000 + indexPath.row + 100
                
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
    // 추가예정
}
