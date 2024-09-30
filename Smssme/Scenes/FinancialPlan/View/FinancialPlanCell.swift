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
    
    private let titleLabel = LabelFactory.titleLabel()
        .build()
    private let descriptionLabel = LabelFactory.bodyLabel()
        .setColor(.bodyGray)
        .build()

    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        cellBackgroundColor(UIColor.white)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        [
            iconView,
            titleLabel,
            descriptionLabel,
        ].forEach { contentView.addSubview($0) }
        
        iconView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.leading.equalToSuperview().offset(16)
            $0.width.equalTo(60)
            $0.height.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(iconView.snp.bottom)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
    }
    
    func cellBackgroundColor(_ color: UIColor) {
        contentView.backgroundColor = color
        contentView.backgroundColor = color.withAlphaComponent(0.5)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 5, height: 3)
        layer.shadowRadius = 3
    }
    
    func configure(with planType: PlanType) {
        iconView.image = UIImage(named: planType.iconName)
        titleLabel.text = planType.title
        descriptionLabel.text = planType.planDescription
    }
}
