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

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let assetLabel: UILabel = {
        let label = UILabel()
        label.text = "총 자산"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    private let assetTextField: UITextField = {
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

    private let savingsTextField: UITextField = {
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

    private let interestRateTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "수익률 입력"
        textField.keyboardType = .decimalPad
        return textField
    }()

    private let calculateButton: UIButton = {
        let button = UIButton()
        button.setTitle("계산하기", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(calculateButtonTapped), for: .touchUpInside) // 버튼 클릭 액션 추가
        return button
    }()
    
    private let barChartView: BarChartView = {
        let barChartView = BarChartView()
        barChartView.rightAxis.enabled = false // 오른쪽 축 숨기기
        barChartView.xAxis.labelPosition = .bottom // x축 레이블 아래쪽에 표시
        barChartView.xAxis.drawGridLinesEnabled = false // x축 그리드라인 숨기기
        barChartView.legend.horizontalAlignment = .center // 수평 중앙 정렬
        barChartView.legend.verticalAlignment = .top // 상단 정렬
        return barChartView
    }()
    
    // MARK: - View Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configueTextField()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    // MARK: - Private Methods
    private func configueTextField() {
        [assetTextField, savingsTextField].forEach {
            $0.delegate = self
        }
    }
    
    private func calculateFutureGraph(currentAsset: Double, annualSavings: Double, interestRate: Double, years: Int) -> ([Double], [Double]) {
        var futureAssetValues: [Double] = []  // 총 자산 미래 가치
        var futureSavingsValues: [Double] = [] // 저축액 미래 가치
        
        for n in 1...years {
            // 총 자산의 미래 가치
            let futureValueAsset = currentAsset * pow(1 + interestRate, Double(n))
            futureAssetValues.append(futureValueAsset)
            
            // 연간 저축액의 미래 가치
            let futureValueSavings = annualSavings * (pow(1 + interestRate, Double(n)) - 1) / interestRate
            futureSavingsValues.append(futureValueSavings)
        }
        
        return (futureAssetValues, futureSavingsValues)
    }
    
    private func updateChartData(futureAssets: [Double], futureSavings: [Double]) {
        var assetEntries: [BarChartDataEntry] = []
        var savingsEntries: [BarChartDataEntry] = []
        
        for (index, value) in futureAssets.enumerated() {
            let entry = BarChartDataEntry(x: Double(index), y: value)
            assetEntries.append(entry)
        }
        
        for (index, value) in futureSavings.enumerated() {
            let entry = BarChartDataEntry(x: Double(index), y: value)
            savingsEntries.append(entry)
        }
        
        let assetDataSet = BarChartDataSet(entries: assetEntries, label: "현재 자산의 미래가치")
        assetDataSet.colors = [UIColor.systemBlue.withAlphaComponent(0.5)]
        assetDataSet.drawValuesEnabled = false
        
        let savingsDataSet = BarChartDataSet(entries: savingsEntries, label: "저축액의 미래가치")
        savingsDataSet.colors = [UIColor.systemGreen.withAlphaComponent(0.5)]
        savingsDataSet.drawValuesEnabled = false
        
        let chartData = BarChartData(dataSets: [savingsDataSet, assetDataSet])
        
        barChartView.data = chartData
        
        let yAxis = barChartView.leftAxis
        yAxis.valueFormatter = DefaultAxisValueFormatter(block: { (value, axis) -> String in
            return "\(Int(value / 1_000_000))백만"
        })
        
        barChartView.notifyDataSetChanged()
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
        
        [titleLabel, barChartView, stackView].forEach {
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
    }
    
    //MARK: - Objc
    @objc private func calculateButtonTapped() {
        let formatter = KoreanCurrencyFormatter.shared
        
        guard let assetText = assetTextField.text, let asset = formatter.number(from: assetText),
              let savingsText = savingsTextField.text, let savings = formatter.number(from: savingsText),
              let interestRateText = interestRateTextField.text, let interestRate = Double(interestRateText) else {
            // 입력이 잘못된 경우 경고 메시지 출력
            print("잘못된 입력입니다.")
            return
        }

        let interestRatePercentage = interestRate / 100 // 퍼센트를 소수로 변환
        let years = 20 // 20년간의 데이터를 계산
        
        let (futureAssets, futureSavings) = calculateFutureGraph(currentAsset: Double(asset), annualSavings: Double(savings), interestRate: interestRatePercentage, years: years)
        
        updateChartData(futureAssets: futureAssets, futureSavings: futureSavings)
    }
}

extension FutureGraphView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) && string != "" {
            return false
        }
        
        var currentText = textField.text ?? ""
        
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if currentText == "0" && string != "" {
            currentText = string
        } else {
            currentText = newText
        }
        
        let formattedText = formatNumberWithComma(currentText)
        
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

