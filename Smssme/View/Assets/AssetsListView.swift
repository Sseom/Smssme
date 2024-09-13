//
//  AssetsEditView.swift
//  Smssme
//
//  Created by 전성진 on 8/30/24.
//

import SnapKit
import UIKit

class AssetsListView: UIView {
    //MARK: - Factory Component Properties
    
    //MARK: - Component Properties
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        return tableView
    }()
    
    let addButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        barButton.title = "자산 추가"
        return barButton
    }()
    
    // MARK: - View Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
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
