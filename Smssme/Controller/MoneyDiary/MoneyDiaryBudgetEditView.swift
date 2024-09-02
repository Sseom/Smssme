//
//  MoneyDiaryEditView.swift
//  Smssme
//
//  Created by 전성진 on 8/30/24.
//

import SnapKit
import UIKit

class MoneyDiaryBudgetEditView: UIView {
    //MARK: - Factory Component Properties
    
    
    //MARK: - Component Properties
//    private let scrollView: UIScrollView = {
//       let scrollView = UIScrollView()
//        return scrollView
//    }()
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    // MARK: - View Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    // MARK: - Private Method
        
    private func setupUI() {
        [tableView].forEach {
            self.addSubview($0)
        }

        tableView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    //MARK: - Objc
}
