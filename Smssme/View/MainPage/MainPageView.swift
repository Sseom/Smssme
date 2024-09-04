import DGCharts
import SnapKit
import UIKit

class MainPageView: UIView {
    // MARK: Properties
    private let mainWelcomeTitleLabel = LargeTitleLabel().createLabel(with: "어서오세요, 전성진 님", color: .black)
    private let totalAssetsTitleLabel = SmallTitleLabel().createLabel(with: "총 자산", color: .black)
    private let totalAssetsValueLabel = LargeTitleLabel().createLabel(with: "900,000,000 원", color: .black)
    private let financialTitleLabel = SmallTitleLabel().createLabel(with: "오늘의 주요 경제 지표", color: .black)
    private let benefitTitleLabel = SmallTitleLabel().createLabel(with: "2024 청년 혜택 총정리", color: .black)
    
    private let chartArray: [TodayFinancia] = [
        TodayFinancia(title: "KOSPI", value: 5678.91, range: -1),
        TodayFinancia(title: "KOSDAQ", value: 234.2, range: 0),
        TodayFinancia(title: "환율", value: 1.233, range: 0),
        TodayFinancia(title: "NASDAQ", value: 4252.33, range: 0)
    ]
    
    private let benefitData: [String] = ["테스트1 데이터 입니다.", "테스트2 데이터 입니다.", "테스트3 데이터 입니다.", "테스트4 데이터 입니다."]
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let financialScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let financialHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let pieChartView: PieChartView = {
        let pieChartView = PieChartView()
        return pieChartView
    }()
    
    let chartCenterButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let benefitVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }()

    
    // MARK: - View Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupTodayFinancia(todayFinanciaData: chartArray)
        setupBenefit(benefitData: benefitData)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func setupTodayFinancia(todayFinanciaData: [TodayFinancia]) {
        todayFinanciaData.forEach {
            let financialVerticalStackView = UIStackView()
            financialVerticalStackView.axis = .vertical
            financialVerticalStackView.distribution = .fill
            
            let titleLabel = UILabel()
            titleLabel.text = "\($0.title)"
            titleLabel.textAlignment = .left
            titleLabel.textColor = .gray
            
            let valueRangeStackView = UIStackView()
            valueRangeStackView.axis = .horizontal
            valueRangeStackView.distribution = .fill
            
            let valueLabel = UILabel()
            valueLabel.text = "\($0.value)"
            valueLabel.textAlignment = .left
            
            let rangeLabel = UILabel()
            rangeLabel.text = "\($0.range)"
            rangeLabel.textAlignment = .left
            rangeLabel.textColor = .systemBlue
            
            financialHorizontalStackView.addArrangedSubview(financialVerticalStackView)
            
            [valueLabel, rangeLabel].forEach {
                valueRangeStackView.addArrangedSubview($0)
            }
            
            [titleLabel, valueRangeStackView].forEach {
                financialVerticalStackView.addArrangedSubview($0)
            }
        }
    }
    
    func setupBenefit(benefitData: [String]) {
        benefitData.forEach {
            let titleLabel = UILabel()
            titleLabel.text = "\($0)"
            titleLabel.textAlignment = .left
            titleLabel.textColor = .gray
            benefitVerticalStackView.addArrangedSubview(titleLabel)
        }
        
        contentView.addSubview(benefitVerticalStackView)
    }
    
    private func setChartData(chartView: PieChartView, chartDataEntries: [ChartDataEntry]) {
        let data = PieChartDataSet(entries: chartDataEntries, label: "자산1")
        let chartData = PieChartData(dataSet: data)
        chartView.centerText = "총 자산\n2,000,000 원"
        chartView.data = chartData
    }
    
    func entryData(values: [Double]) -> [ChartDataEntry] {
        var pieDataEntries: [ChartDataEntry] = []
        for i in 0 ..< values.count {
            let pieDataEntry = ChartDataEntry(x: Double(i), y: values[i])
            pieDataEntries.append(pieDataEntry)
        }
        
        return pieDataEntries
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        // 스크롤 뷰 추가
        self.addSubview(scrollView)
        
        [scrollView].forEach {
            self.addSubview($0)
        }
        
        [contentView].forEach {
            scrollView.addSubview($0)
        }
        
        [
            mainWelcomeTitleLabel,
            totalAssetsTitleLabel,
            pieChartView,
            chartCenterButton,
            financialTitleLabel,
            financialScrollView,
            benefitTitleLabel,
            benefitVerticalStackView
        ].forEach {
            contentView.addSubview($0)
        }
        
        [financialHorizontalStackView].forEach {
            financialScrollView.addSubview($0)
        }

        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(contentView.snp.height)
        }
        
        mainWelcomeTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview().offset(10)
        }
        
        totalAssetsTitleLabel.snp.makeConstraints {
            $0.top.equalTo(mainWelcomeTitleLabel.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(10)
        }
        
        pieChartView.snp.makeConstraints {
            $0.top.equalTo(totalAssetsTitleLabel.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(30)
            $0.height.equalTo(pieChartView.snp.width).multipliedBy(1.0)
        }
        
        chartCenterButton.snp.makeConstraints {
            $0.edges.equalTo(pieChartView.snp.edges).inset(120)
        }
        
        financialTitleLabel.snp.makeConstraints {
            $0.top.equalTo(pieChartView.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(10)
        }
        
        financialScrollView.snp.makeConstraints {
            $0.top.equalTo(financialTitleLabel.snp.bottom).offset(20)
            $0.height.equalTo(40)
            $0.left.right.equalToSuperview().offset(10)
        }
        
        financialHorizontalStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }
        
        benefitTitleLabel.snp.makeConstraints {
            $0.top.equalTo(financialScrollView.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(10)
        }
        
        benefitVerticalStackView.snp.makeConstraints {
            $0.top.equalTo(benefitTitleLabel.snp.bottom).offset(5)
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().offset(-20)
        }
    }
}
