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
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "월급"
        label.textAlignment = .left
        return label
    }()
    
    var amountLabel: UILabel = {
        let label = UILabel()
        label.text = "23,000원"
        label.textAlignment = .left
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "05:36"
        label.textColor = .lightGray
        label.textAlignment = .right
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
    
    
    func updateData(transaction: Diary){
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let time = dateFormatter.string(from: transaction.date ?? Date())
        
        amountLabel.text = KoreanCurrencyFormatter.shared.string(from: transaction.amount)
        
        print(transaction.statement)
        if transaction.statement {  // false: 지출 - red
            amountLabel.textColor = .blue
        } else {
            amountLabel.textColor = .red
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
