//
//  MoneyDiaryBudgetEditCell.swift
//  Smssme
//
//  Created by 전성진 on 9/2/24.
//

import UIKit

class AssetsListCell: UITableViewCell {
    
    // MARK: - Properties
    var assets: AssetsItem? {
        didSet {
            setupData()
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        return label
    }()
        
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupData() {
        guard let assets = assets else { return }
        
        titleLabel.text = assets.title
        amountLabel.text = KoreanCurrencyFormatter.shared.string(from: assets.amount)
    }
    
    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(amountLabel)
        
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(contentView.snp.left).offset(16)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.trailing.equalTo(amountLabel.snp.leading).offset(-16)
            $0.width.equalTo(contentView.snp.width).multipliedBy(0.3)
        }
        
        amountLabel.snp.makeConstraints {
            $0.right.equalTo(contentView.snp.right).offset(-8)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.width.equalTo(100)
        }
    }
}
