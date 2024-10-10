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
        return tableView
    }()
    
    let totalView: MoneyDiaryBudgetEditHeaderView = {
        let headerView = MoneyDiaryBudgetEditHeaderView()
        
        headerView.titleLabel.text = "잉여금액"
        return headerView
    }()
    
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
}
