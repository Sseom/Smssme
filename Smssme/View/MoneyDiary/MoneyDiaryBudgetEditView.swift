//
//  MoneyDiaryEditView.swift
//  Smssme
//
//  Created by 전성진 on 8/30/24.
//

import SnapKit
import UIKit

class MoneyDiaryBudgetEditView: UIView {
    // MARK: - Component Properties
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    let totalView: MoneyDiaryBudgetEditHeaderView = MoneyDiaryBudgetEditHeaderView(section: 3, titleText: "잉여금액")
    
    // MARK: - View Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method

    // MARK: - Private Method
        
    private func setupUI() {
        [tableView, totalView].forEach {
            self.addSubview($0)
        }

        tableView.snp.makeConstraints {
            $0.top.left.right.equalTo(self.safeAreaLayoutGuide)
            $0.bottom.equalTo(totalView.snp.top)
        }
        
        totalView.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.left.right.equalTo(self.safeAreaLayoutGuide)
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    private func setupGestureRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        recognizer.cancelsTouchesInView = false // Allow touches to be processed by other views
        self.addGestureRecognizer(recognizer)
    }
    
    // MARK: - Objc
    @objc private func handleTap() {
        self.endEditing(true)
    }
}
