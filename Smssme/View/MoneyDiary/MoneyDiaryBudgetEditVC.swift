//
//  MoneyDiaryEditVC.swift
//  Smssme
//
//  Created by 전성진 on 8/30/24.
//

import UIKit

class MoneyDiaryBudgetEditVC: UIViewController {
    //MARK: - Properties
    private let moneyDiaryBudgetEditView: MoneyDiaryBudgetEditView = MoneyDiaryBudgetEditView()
    
    // 데이터 모델
    var financialPlans = [
        FinancialPlan(title: "수입 플랜", items: [FinancialItem(name: "월급", amount: "3000000"), FinancialItem(name: "보너스", amount: "500000")]),
        FinancialPlan(title: "재무 목표 플랜", items: [FinancialItem(name: "비상금", amount: "1000000"), FinancialItem(name: "투자", amount: "2000000")]),
        FinancialPlan(title: "소비 플랜", items: [FinancialItem(name: "식비", amount: "500000"), FinancialItem(name: "교통비", amount: "200000")])
    ]
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
        // 네비게이션 바에 플러스 버튼 추가
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        
        // 데이터소스 및 델리게이트 설정
        moneyDiaryBudgetEditView.tableView.dataSource = self
        moneyDiaryBudgetEditView.tableView.delegate = self
    }
    
    override func loadView() {
        super.loadView()
        self.view = moneyDiaryBudgetEditView
    }
    
    // MARK: - Method
    
    func calculateTotalAmount(forSection section: Int) -> String {
        let total = financialPlans[section].items.reduce(0) { sum, item in
            return sum + (Int(item.amount) ?? 0)
        }
        return "\(total) 원"
    }
    
    func addNewItem(toSection section: Int) {
        let newItem = FinancialItem(name: "", amount: "")
        financialPlans[section].items.append(newItem)
        financialPlanView.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
    
    // MARK: - Private Method
    
    // MARK: - Objc
}

// MARK: - UITableViewDataSource
extension MoneyDiaryBudgetEditVC: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return financialPlans.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let planTitle = financialPlans[section].title
        let totalAmount = calculateTotalAmount(forSection: section)
        return "\(planTitle) - 총 금액: \(totalAmount)"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return financialPlans[section].items.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let plan = financialPlans[indexPath.section]

        if indexPath.row < plan.items.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FinancialItemCell", for: indexPath) as! FinancialItemCell
            let item = plan.items[indexPath.row]
            
            cell.nameTextField.text = item.name
            cell.amountTextField.text = item.amount
            
            cell.nameTextField.delegate = self
            cell.amountTextField.delegate = self
            
            cell.nameTextField.tag = indexPath.section * 1000 + indexPath.row
            cell.amountTextField.tag = indexPath.section * 1000 + indexPath.row + 100
            
            return cell
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
        
        if indexPath.row == financialPlans[indexPath.section].items.count {
            addNewItem(toSection: indexPath.section)
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            financialPlans[indexPath.section].items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

// MARK: - UITableViewDelegate
extension MoneyDiaryBudgetEditVC: UITableViewDelegate {
    // UITableViewDelegate 관련 메서드는 현재 추가적인 기능이 없으므로 비워둡니다.
}

// MARK: - UITextFieldDelegate
extension MoneyDiaryBudgetEditVC: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        let section = textField.tag / 1000
        let row = textField.tag % 1000
        
        if textField.tag % 100 == 0 {
            financialPlans[section].items[row].name = textField.text ?? ""
        } else {
            financialPlans[section].items[row].amount = textField.text ?? ""
            moneyDiaryBudgetEditView.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
        }
    }
}

struct FinancialItem {
    var name: String    // 항목명
    var amount: String  // 금액
}

struct FinancialPlan {
    let title: String      // 큰 항목의 제목
    var items: [FinancialItem]    // 하위 항목들의 목록
}
