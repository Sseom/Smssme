//
//  FinancialPlanCompleteCell.swift
//  Smssme
//
//  Created by 임혜정 on 9/25/24.
//

import SnapKit
import UIKit

class FinancialPlanCompleteCell: UICollectionViewCell {
    static let ID = "FinancialPlanCompleteCell"
    
    private let badgeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "badge")
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private let plan = LabelFactory.bodyLabel()
        .setText("목표이름")
        .build()
    private let date = LabelFactory.captionLabel()
        .setText("2024.9.25")
        .setColor(.bodyGray)
        .build()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        [
            badgeImage,
            plan,
            date
        ].forEach {
            contentView.addSubview($0)
        }
        
        badgeImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.width.height.equalTo(100)
            $0.centerX.equalToSuperview()
        }
        
        plan.snp.makeConstraints {
            $0.top.equalTo(badgeImage.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        date.snp.makeConstraints {
            $0.top.equalTo(plan.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
    }
    
    func configure(with plan: FinancialPlanDTO) {
        self.plan.text = plan.title
        self.date.text = "\(PlanDateModel.dateFormatter.string(from: plan.completionDate)) 완료"
    }
}
