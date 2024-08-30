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
        let segmentControl = UISegmentedControl()
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
    }()
    
    // MARK: - View Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
