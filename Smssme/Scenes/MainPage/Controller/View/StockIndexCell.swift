//
//  StockIndexCell.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/23/24.
//

import SnapKit
import UIKit

class StockIndexCell: UICollectionViewCell {
    static let reuseIdentifier = "StockIndexCell"
    
    // 주요 지수 명
    let titleLabel = LabelFactory.subTitleLabel()
        .setColor(.bodyGray)
        .build()
    
    // 지수
    let valueLabel = LabelFactory.subTitleLabel()
        .setFont(.boldSystemFont(ofSize: 18))
        .build()
    
    // 전일 대비 등락(등락포인트와 등락률을 함께 표시)
    let changeRateLabel = LabelFactory.captionLabel()
        .build()

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI 설정
    private func configureUI() {
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        contentView.backgroundColor = UIColor(hex: "#e9f3fd").withAlphaComponent(0.4)
        
        [titleLabel, valueLabel, changeRateLabel].forEach { contentView.addSubview($0) }
    }
    
    private func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(8)
        }
        
        valueLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(8)
        }
        
        changeRateLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-8)
            $0.leading.equalToSuperview().offset(8)
        }
    }
    
    // 통합모델에 입력된 데이터를 라벨에 설정
    func configure(stockIndexData: StockIndexData) {
        titleLabel.text = stockIndexData.indexName
        valueLabel.text = stockIndexData.indexValue
        
        // 지수 UI 업데이트
        guard let change = Double(stockIndexData.changePoint ?? "0.00") else {return}
        
        if change > 0.0 {
                changeRateLabel.textColor = .systemRed
            changeRateLabel.text = "▲ \(stockIndexData.changePoint ?? "0.00") (\(stockIndexData.changeRate ?? "0.000")%)"
        } else if change < 0.0 {
            changeRateLabel.textColor = .systemBlue
            changeRateLabel.text = "▼ \(stockIndexData.changePoint ?? "0.00") (\(stockIndexData.changeRate ?? "0.000")%)"
        } else {
            changeRateLabel.text = "0.000 (0.000)%"
        }
    }
}
