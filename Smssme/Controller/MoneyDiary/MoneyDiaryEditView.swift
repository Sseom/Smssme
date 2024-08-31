//
//  MoneyDiaryEditView.swift
//  Smssme
//
//  Created by 전성진 on 8/30/24.
//

import SnapKit
import UIKit

class MoneyDiaryEditView: UIView {
    private let segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["수입", "지출"])
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
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
        [segmentControl].forEach {
            self.addSubview($0)
        }
        
        segmentControl.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.left.right.equalTo(self.safeAreaLayoutGuide).inset(10)
        }
    }
}
