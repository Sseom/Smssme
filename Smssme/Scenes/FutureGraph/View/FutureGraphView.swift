//
//  FutureGraphView.swift
//  Smssme
//
//  Created by 전성진 on 9/26/24.
//

import DGCharts
import SnapKit
import UIKit

class FutureGraphView: UIView {
    // MARK: Properties
    private let titleLabel = LabelFactory.titleLabel().setText("내가 만들어보는\n자산 그래프").setAlign(.center).build()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = false
        return scrollView
    }()
    
    private let assetLabel: UILabel = {
        let label = UILabel()
        label.text = "총 자산"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let assetTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "총 자산 입력"
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    private let savingsLabel: UILabel = {
        let label = UILabel()
        label.text = "저축액"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let savingsTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "저축액 입력"
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    private let interestRateLabel: UILabel = {
        let label = UILabel()
        label.text = "수익률 (%)"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let interestRateTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "수익률 입력"
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    let calculateButton: UIButton = {
        let button = UIButton()
        button.setTitle("차트 만들기", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    let barChartView: BarChartView = {
        let chartView = BarChartView()
        chartView.rightAxis.enabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.legend.horizontalAlignment = .center
        chartView.legend.verticalAlignment = .top
        chartView.noDataText = "아래 내용을 입력해 주세요."
        return chartView
    }()
    
    // MARK: - Table View
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isScrollEnabled = false
        tableView.isHidden = true
        return tableView
    }()

    // MARK: - View Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        configueTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func configueTextField() {
        [assetTextField, savingsTextField].forEach {
            $0.delegate = self
        }
    }
    
    private func setupUI() {
        let assetStackView = UIStackView(arrangedSubviews: [assetLabel, assetTextField])
        assetStackView.axis = .horizontal
        assetStackView.spacing = 10
        assetLabel.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        
        let savingsStackView = UIStackView(arrangedSubviews: [savingsLabel, savingsTextField])
        savingsStackView.axis = .horizontal
        savingsStackView.spacing = 10
        savingsLabel.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        
        let interestRateStackView = UIStackView(arrangedSubviews: [interestRateLabel, interestRateTextField])
        interestRateStackView.axis = .horizontal
        interestRateStackView.spacing = 10
        interestRateLabel.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        
        let stackView = UIStackView(arrangedSubviews: [assetStackView, savingsStackView, interestRateStackView, calculateButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        
        [scrollView].forEach {
            self.addSubview($0)
        }
        
        [titleLabel, barChartView, stackView, tableView].forEach {
            scrollView.addSubview($0)
        }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.centerX.equalToSuperview()
        }
        
        barChartView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(30)
            $0.height.equalTo(barChartView.snp.width).multipliedBy(0.8)
            $0.centerX.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(barChartView.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(20)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(600)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}

extension FutureGraphView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) && string != "" {
            return false
        }
        
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        let formattedText = formatNumberWithComma(newText)
        textField.text = formattedText
        
        return false
    }
    
    private func formatNumberWithComma(_ number: String) -> String {
        let numberString = number.replacingOccurrences(of: ",", with: "")
        
        if let numberValue = Int(numberString) {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            return numberFormatter.string(from: NSNumber(value: numberValue)) ?? number
        }
        
        return number
    }
}
