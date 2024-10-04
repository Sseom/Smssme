//
//  DailyTransactionCell.swift
//  Smssme
//
//  Created by KimRin on 8/29/24.
//0924 rin

import UIKit

final class DailyTransactionCell: UICollectionViewCell, CellReusable {
    private let categoryImage = UIImageView()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    private lazy var contentsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, amountLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupCellUI()
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func updateData(transaction: Diary){
        let time = DateFormatter.hourMinutesKr.string(from: transaction.date ?? Date())
        
        amountLabel.text = KoreanCurrencyFormatter.shared.string(from: transaction.amount)
        
        print(transaction.statement)
        if transaction.statement {
            amountLabel.textColor = .primaryBlue
            categoryImage.image = UIImage(systemName: "plus.circle")
            categoryImage.tintColor = .primaryBlue
        } else {
            amountLabel.textColor = .red
            categoryImage.image = UIImage(systemName: "minus.circle")
            categoryImage.tintColor = .systemRed
        }
        
        nameLabel.text = transaction.title
        timeLabel.text = time
        
    }
    
    private func setupCellUI() {
        [categoryImage, contentsStackView, timeLabel].forEach { self.addSubview($0) }
        
    }
    private func setupLayout() {
        self.categoryImage.snp.makeConstraints {
            $0.leading.equalTo(self.snp.leading).offset(10)
            $0.centerY.equalTo(self)
            $0.width.height.equalTo(40)
        }
        
        self.contentsStackView.snp.makeConstraints {
            $0.leading.equalTo(self.categoryImage.snp.trailing).offset(10)
            $0.centerY.equalTo(self)
        }
        
        self.timeLabel.snp.makeConstraints {
            $0.trailing.equalTo(self.snp.trailing).inset(20)
            $0.centerY.equalTo(self)
        }
    }
    
    
}
