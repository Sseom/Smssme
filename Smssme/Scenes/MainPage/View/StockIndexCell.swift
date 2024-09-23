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
    
    let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    //지수
    let valueLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    //전일 대비 등락
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
        [titleLabel, valueLabel, changeRateLabel].forEach { stackView.addArrangedSubview($0)}
    }
    
    private func setupLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(5)
        }
    }
    
}
