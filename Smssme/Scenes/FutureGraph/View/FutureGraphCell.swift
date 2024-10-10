//
//  FutureGraphCell.swift
//  Smssme
//
//  Created by 전성진 on 9/27/24.
//

import UIKit

class FutureGraphCell: UITableViewCell {
    static let identifier = "FutureGraphCell"
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()

    private let assetLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let savingsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContentView()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContentView() {
//        contentView.backgroundColor = UIColor(white: 0.95, alpha: 1) // 셀 배경색
//        contentView.layer.cornerRadius = 8 // 모서리 둥글게
//        contentView.layer.masksToBounds = true
    }
    
    func setupUI() {
        [yearLabel, assetLabel, savingsLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [stackView].forEach {
            contentView.addSubview($0)
        }
        
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        yearLabel.snp.makeConstraints {
            $0.width.equalTo(40)
        }
        
//        assetLabel.snp.makeConstraints {
//            $0.width.equalTo(175)
//        }
//        
//        savingsLabel.snp.makeConstraints {
//            $0.width.equalTo(130)
//        }
    }
    
    // common으로 빼기
    func formattedCurrencyString(from number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "" // 통화 기호를 없애고 싶다면 빈 문자열로 설정
        formatter.usesGroupingSeparator = true // 그룹 구분자 사용
        formatter.groupingSeparator = "," // 그룹 구분자를 콤마로 설정
        formatter.minimumFractionDigits = 0 // 소수점 이하 자리 수
        formatter.maximumFractionDigits = 0
        
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }

    func configure(year: String, asset: Double, savings: Double) {
        yearLabel.text = "\(year)년" // 연도 표시
        assetLabel.text = "총 자산: \(formattedCurrencyString(from: asset + savings)) 원"
    }
}
