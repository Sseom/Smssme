//
//  MoneyDiaryBudgetEditCell.swift
//  Smssme
//
//  Created by 전성진 on 9/2/24.
//

import UIKit

class BenefitVerticalCell: UITableViewCell {
    
    // MARK: - Properties
    let cellIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 18
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let titleLabel = LabelFactory.bodyLabel().build()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {

        self.clipsToBounds = true
        self.layer.cornerRadius = 22
        self.layer.masksToBounds = true

        
        [cellIconView, titleLabel].forEach { contentView.addSubview($0)}
        
        cellIconView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.width.height.equalTo(36)
            $0.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(cellIconView.snp.trailing).offset(16)
            $0.centerY.equalToSuperview()
        }
    }
}
