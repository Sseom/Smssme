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
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor =  UIColor(hex: "#5D6285")
        return label
    }()
    
    // 지수
    let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor =  UIColor(hex: "#060B11")
        return label
    }()
    
    // 전일 대비 등락(등락포인트와 등락률을 함께 표시)
    let changeRateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor =  .systemRed
        return label
    }()

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
        [titleLabel, valueLabel, changeRateLabel].forEach { contentView.addSubview($0) }
    }
    
    private func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(4)
            $0.leading.equalToSuperview()
        }
        
        valueLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview()
        }
        
        changeRateLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(4)
            $0.leading.equalToSuperview()
        }
    }
    
    // 통합모델에 입력된 데이터를 라벨에 설정
    func configure(stockIndexData: StockIndexData) {
        titleLabel.text = stockIndexData.indexName
        valueLabel.text = stockIndexData.indexValue
        
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
