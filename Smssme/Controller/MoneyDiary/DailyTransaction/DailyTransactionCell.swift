//
//  DailyTransactionCell.swift
//  Smssme
//
//  Created by KimRin on 8/29/24.
//

import UIKit

class DailyTransactionCell: UICollectionViewCell, CellReusable {
    let categoryImage: UIImageView = {
        let image = UIImageView()

        image.image = UIImage(systemName: "bitcoinsign.circle")

        return image
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "월급"
        label.textAlignment = .left
        return label
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.text = "23,000원"
        label.textAlignment = .left
        return label
    }()
    
    lazy var contentsStackView: UIStackView = {
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
    
    private func setupCellUI() {
        [categoryImage, contentsStackView].forEach { self.addSubview($0) }

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
    }

    func transformToText(transactionItem: TransactionItem){
        self.nameLabel.text = transactionItem.name
        self.amountLabel.text = "\(transactionItem.Amount) 원"
        if transactionItem.isIncom {
            self.amountLabel.textColor = .blue
            self.nameLabel.textColor = .blue
            
        }
        else {
            self.amountLabel.textColor = .red
            self.nameLabel.textColor = .red
        }
        self.categoryImage.image = UIImage(systemName: "bitcoinsign.circle")
        
    }

}
