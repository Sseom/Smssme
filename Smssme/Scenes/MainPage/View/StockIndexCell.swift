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
        label.text = "코스피"
        label.backgroundColor = .red
        return label
    }()
    
    // 지수
    let valueLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .blue
        return label
    }()
    
    // 전일 대비 등락(등락포인트와 등락률을 함께 표시)
    let changeRateLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
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
        [stackView].forEach { self.addSubview($0)}
        
        [titleLabel, valueLabel, changeRateLabel].forEach { stackView.addArrangedSubview($0)}
    }
    
    private func setupLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide).inset(5)
        }
    }
    
    // 통합모델에 입력된 데이터를 라벨에 설정
    func configure(stockIndexData: StockIndexData) {
        titleLabel.text = stockIndexData.indexName
        valueLabel.text = stockIndexData.indexValue
        changeRateLabel.text = "\(stockIndexData.changePoint) (\(stockIndexData.changeRate)%)"
    }
}
