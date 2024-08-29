//
//  FinancialPlanCell.swift
//  Smssme
//
//  Created by 임혜정 on 8/27/24.
//

import UIKit
import SnapKit

class FinancialPlanCell: UICollectionViewCell {
    static let ID = "FinancialPlanCell"
    
    private let titleLabel = SmallTitleLabel().createLabel(with: "", color: UIColor.black)
    private let descriptionLabel = ContentLabel().createLabel(with: "", color: UIColor.systemGray2)
    private let selectButton = BaseButton().createButton(text: "시작하기", color: UIColor.systemGray2, textColor: UIColor.white)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        cellBackgroundColor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [titleLabel, descriptionLabel, selectButton].forEach {
            contentView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        selectButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-32)
            $0.width.equalTo(80)
            $0.height.equalTo(32)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func cellBackgroundColor() {
        contentView.backgroundColor = .lightGray
    }
    
    func configure(with item: FinancialPlanSelectionVC.PlanItem) {
        titleLabel.text = item.title
        descriptionLabel.text = item.description
    }
}
