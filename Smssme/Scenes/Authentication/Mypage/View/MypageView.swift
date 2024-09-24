//
//  Mypage.swift
//  Smssme
//
//  Created by ahnzihyeon on 8/29/24.
//

import UIKit
import FirebaseAuth

class MypageView: UIView {
    
    // 테이블뷰
        lazy var tableView = UITableView(frame: .zero, style: .grouped)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        [tableView].forEach { self.addSubview($0) }
    }

    
}
