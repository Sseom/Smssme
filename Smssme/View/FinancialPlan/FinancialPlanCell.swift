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
    private let descriptionLabel = ContentLabel().createLabel(with: "", color: UIColor(hex: "#333333"))
    private let startLabel: UILabel = {
        let label = UILabel()
        label.text = "시작하기"
        label.textAlignment = .center
        label.textColor = UIColor(hex: "#333333")
        label.backgroundColor = UIColor(hex: "#e3e3e3")
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        return label
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
        [titleLabel, descriptionLabel, startLabel].forEach {
            contentView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        startLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-20)
            $0.width.equalTo(80)
            $0.height.equalTo(32)
            $0.centerX.equalToSuperview()
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
    
    func configure(with item: PlanItem) {
        //        cellBackImage.image = UIImage(named: item.imageName)
        titleLabel.text = item.title
        descriptionLabel.text = item.description
        
        // 사용자 정의 플랜인 경우
        if let uuid = item.uuid {
            // UUID를 사용한 추가
            self.tag = uuid.hashValue
        }
    }
}
