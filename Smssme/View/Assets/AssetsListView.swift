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
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    // MARK: - View Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        // 터치시 키보드 내림
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(touch))
        self.addGestureRecognizer(recognizer)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    // MARK: - Private Method
    private func setupUI() {
        
    }
    
    //MARK: - Objc
    @objc func touch() {
        self.endEditing(true)
    }

}
