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
    
    // 셀 배경 이미지를 적용할 경우의 회의되어야할 점. 대안을 생각해야함
    //    private let cellBackImage: UIImageView = {
    //        let backImage = UIImageView()
    //        backImage.contentMode = .scaleAspectFill
    //        backImage.clipsToBounds = true
    //        return backImage
    //    }()
    
    private let titleLabel = SmallTitleLabel().createLabel(with: "", color: UIColor.black)
    private let descriptionLabel = ContentLabel().createLabel(with: "", color: UIColor(hex: "#333333"))
    private let selectButton = BaseButton().createButton(text: "시작하기", color: UIColor(hex: "#777777"), textColor: UIColor.white)
    
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
        [titleLabel, descriptionLabel, selectButton].forEach {
            contentView.addSubview($0)
        }
        // 셀 배경 이미지를 적용할 경우의 회의되어야할 점. 대안을 생각해야함
        //        cellBackImage.snp.makeConstraints {
        //            $0.edges.equalToSuperview()
        //        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        selectButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-20)
            $0.width.equalTo(80)
            $0.height.equalTo(32)
            $0.centerX.equalToSuperview()
        }
    }
    
    func cellBackgroundColor(_ color: UIColor) {
        contentView.backgroundColor = color
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
