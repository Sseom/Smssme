//
//  FutureGraphView.swift
//  Smssme
//
//  Created by 전성진 on 9/26/24.
//

import DGCharts
import SnapKit
import UIKit

class FutureGraphSecondView: UIView {
    // MARK: Properties
    private let titleLabel = LabelFactory.titleLabel().setText("미래자산 그래프").setAlign(.center).build()
    private let diagnosisTitleLabel = LabelFactory.subTitleLabel().setText("진단").setAlign(.left).build()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = false
        return scrollView
    }()
    
    private let savingsLabel: UILabel = {
        let label = UILabel()
        label.text = "목표 자산"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let savingsTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "목표 자산 입력"
        textField.keyboardType = .decimalPad
        textField.text = "0"
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
        chartView.noDataText = "목표 자산을 입력해 주세요."
        chartView.isUserInteractionEnabled = false // 터치 이벤트 자체를 비활성화
        chartView.highlightPerTapEnabled = false // 차트를 터치했을 때 하이라이트 효과 제거
        chartView.dragEnabled = false // 드래그 비활성화
        chartView.pinchZoomEnabled = false // 핀치 줌 비활성화
        chartView.doubleTapToZoomEnabled = false // 더블 탭 줌 비활성화
        return chartView
    }()
    
    
    
    // 첫 번째 InfoView
    let firstFutureAssetAmountLabel = UILabel()
    let firstSavingsAmountLabel = UILabel()
    let firstTotalAssetAmountLabel = UILabel()
    let firstInterestRateAmountLabel = UILabel()

    lazy var firstInfoView: UIView = {
        let view = UIView()
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5

        let firstFutureAssetTitleLabel = UILabel()
        firstFutureAssetTitleLabel.text = "20년후 미래 예상 자산"
        firstFutureAssetAmountLabel.text = "0 원"

        let firstSavingsTitleLabel = UILabel()
        firstSavingsTitleLabel.text = "연 평균 저축액"
        firstSavingsAmountLabel.text = "0 원"

        let firstTotalAssetTitleLabel = UILabel()
        firstTotalAssetTitleLabel.text = "현재 총 자산"
        firstTotalAssetAmountLabel.text = "0 원"

        let firstInterestRateTitleLabel = UILabel()
        firstInterestRateTitleLabel.text = "한국 10년 국채수익률"
        firstInterestRateAmountLabel.text = "3.03%"

        [firstFutureAssetTitleLabel,
         firstFutureAssetAmountLabel,
         firstSavingsTitleLabel,
         firstSavingsAmountLabel,
         firstTotalAssetTitleLabel,
         firstTotalAssetAmountLabel,
         firstInterestRateTitleLabel,
         firstInterestRateAmountLabel
        ].forEach {
            stackView.addArrangedSubview($0)
        }

        view.addSubview(stackView)

        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        return view
    }()

    // 두 번째 InfoView
    let secondFutureAssetAmountLabel = UILabel()
    let secondSavingsAmountLabel = UILabel()
    let secondTotalAssetAmountLabel = UILabel()
    let secondInterestRateAmountLabel = UILabel()

    lazy var secondInfoView: UIView = {
        let view = UIView()
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5

        let secondFutureAssetTitleLabel = UILabel()
        secondFutureAssetTitleLabel.text = "20년후 목표 예상 자산"
        secondFutureAssetAmountLabel.text = "0 원"

        let secondSavingsTitleLabel = UILabel()
        secondSavingsTitleLabel.text = "연 목표 저축액"
        secondSavingsAmountLabel.text = "0 원"

        let secondTotalAssetTitleLabel = UILabel()
        secondTotalAssetTitleLabel.text = "현재 총 자산"
        secondTotalAssetAmountLabel.text = "0 원"

        let secondInterestRateTitleLabel = UILabel()
        secondInterestRateTitleLabel.text = "한국 10년 국채수익률"
        secondInterestRateAmountLabel.text = "3.03%"

        [secondFutureAssetTitleLabel,
         secondFutureAssetAmountLabel,
         secondSavingsTitleLabel,
         secondSavingsAmountLabel,
         secondTotalAssetTitleLabel,
         secondTotalAssetAmountLabel,
         secondInterestRateTitleLabel,
         secondInterestRateAmountLabel
        ].forEach {
            stackView.addArrangedSubview($0)
        }

        view.addSubview(stackView)

        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        return view
    }()
    
    let diagnosisInfoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "자료를 입력해 주세요."
        label.font = .boldSystemFont(ofSize: 16)
        
        return label
    }()

    
    // MARK: - View Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        configueTextField()
        self.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func configueTextField() {
        [savingsTextField].forEach {
            $0.delegate = self
        }
    }
    
    private func viewChange(index: Int) {
        print("뷰 바뀜")
    }
    
    private func setupUI() {
        let savingsStackView = UIStackView(arrangedSubviews: [savingsLabel, savingsTextField])
        savingsStackView.axis = .horizontal
        savingsStackView.spacing = 10
        
        let infoStackView = UIStackView(arrangedSubviews: [firstInfoView, secondInfoView])
        infoStackView.axis = .horizontal
        infoStackView.distribution = .fillEqually
        infoStackView.spacing = 10
        
        savingsLabel.snp.makeConstraints {
            $0.width.equalTo(100)
        }
                
        [scrollView].forEach {
            self.addSubview($0)
        }
        
        [titleLabel, 
         barChartView,
         savingsStackView,
         calculateButton,
         infoStackView,
         diagnosisTitleLabel,
         diagnosisInfoLabel
        ].forEach {
            scrollView.addSubview($0)
        }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
        }
        
        barChartView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(30)
            $0.height.equalTo(barChartView.snp.width).multipliedBy(0.8)
            $0.centerX.equalToSuperview()
        }
        
        savingsStackView.snp.makeConstraints {
            $0.top.equalTo(barChartView.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(30)
        }
        
        calculateButton.snp.makeConstraints {
            $0.top.equalTo(savingsStackView.snp.bottom).offset(15)
            $0.left.right.equalToSuperview().inset(15)
            $0.height.equalTo(30)
        }
        
        infoStackView.snp.makeConstraints {
            $0.top.equalTo(calculateButton.snp.bottom).offset(25)
            $0.left.right.equalToSuperview().inset(15)
            $0.height.equalTo(200)
        }
        
        diagnosisTitleLabel.snp.makeConstraints {
            $0.top.equalTo(infoStackView.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(20)
        }
        
        diagnosisInfoLabel.snp.makeConstraints {
            $0.top.equalTo(diagnosisTitleLabel.snp.bottom).offset(15)
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().offset(-15)
        }
    }
}

extension FutureGraphSecondView: UITextFieldDelegate {
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
