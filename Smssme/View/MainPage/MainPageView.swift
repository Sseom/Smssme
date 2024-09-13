import DGCharts
import SafariServices
import SnapKit
import UIKit

class MainPageView: UIView {
    // MARK: Properties
    var mainWelcomeTitleLabel = LargeTitleLabel().createLabel(with: "씀씀이의 방문을 \n환영합니다.", color: .black)
    private let totalAssetsTitleLabel = SmallTitleLabel().createLabel(with: "총 자산", color: .black)
    let totalAssetsValueLabel = LargeTitleLabel().createLabel(with: "0 원", color: .black)
//    private let financialTitleLabel = SmallTitleLabel().createLabel(with: "오늘의 주요 경제 지표", color: .black)
    private let benefitTitleLabel = SmallTitleLabel().createLabel(with: "2024 청년 혜택 총정리", color: .black)
    

//    private let todayFinancialArray: [TodayFinancial] = [
//        TodayFinancial(title: "KOSPI", value: 5678.91, range: -1),
//        TodayFinancial(title: "KOSDAQ", value: 234.2, range: 0),
//        TodayFinancial(title: "환율", value: 1.233, range: 0),
//        TodayFinancial(title: "NASDAQ", value: 4252.33, range: 0)
//    ]
    
    private let benefitData: [String] = [
        "✅ 청년 취업 및 창업 지원",
        "✅ 청년 주거 지원",
        "✅ 청년 금융 지원",
        "✅ 청년 교육 및 자립 지원",
        "✅ 청년 복지 및 기타지원",
        "✅ 지역별 혜택"
    ]
    
    private let benefitUrl: [String] = [
        "https://valley-porch-b6d.notion.site/1-1001c7ac6761489cbf12b3802a8924a7",
        "https://valley-porch-b6d.notion.site/2-717bb3ae189b4847806ae044d3ddb8b1",
        "https://valley-porch-b6d.notion.site/3-26ee2c8202ec46de854409179727c949?pvs=25",
        "https://valley-porch-b6d.notion.site/4-95f275585ec54a00b0994ae2e7310b5c?pvs=25",
        "https://valley-porch-b6d.notion.site/5-e0eb6ef61c944c82b123284fb58adccc?pvs=4",
        "https://valley-porch-b6d.notion.site/6-2024-28798ac02443464493f80f299772b47b?pvs=4"
    ]
    
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
        pieChartView.rotationEnabled = false
        return pieChartView
    }()
    
    let chartCenterButton: UIButton = {
        let button = UIButton()
        button.setTitle("자산 추가", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemGray4
        return button
    }()
    
    private let benefitVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.layer.borderColor = UIColor.black.cgColor
        stackView.layer.borderWidth = 1
        return stackView
    }()
    
    
    // MARK: - View Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
//        setupTodayFinancia(todayFinanciaData: todayFinancialArray)
        setupBenefit(benefitData: benefitData)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func setupTodayFinancia(todayFinanciaData: [TodayFinancial]) {
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
    
    //MARK: - 청년 혜택 총정리
    func setupBenefit(benefitData: [String]) {
        for (index, benefit) in benefitData.enumerated() {
            let button = UIButton()
            button.setTitle(benefit, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.contentHorizontalAlignment = .left
            button.tag = index
            
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            benefitVerticalStackView.addArrangedSubview(button)
            
            button.snp.makeConstraints {
                $0.width.equalTo(benefitVerticalStackView.snp.width)
                $0.height.equalTo(60)
            }
        }
        contentView.addSubview(benefitVerticalStackView)
    }
    
    // 청년 혜택 노션 url 연결
    @objc private func buttonTapped(_ sender: UIButton) {
          let index = sender.tag
          if index < benefitUrl.count {
              let urlString = benefitUrl[index]
              openSafari(with: urlString)
          }
      }
      
    // 사파리 연결
      private func openSafari(with urlString: String) {
          guard let url = URL(string: urlString) else { return }
          let safariVC = SFSafariViewController(url: url)
          if let topController = UIApplication.shared.windows.first?.rootViewController {
              topController.present(safariVC, animated: true, completion: nil)
          }
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
            totalAssetsValueLabel,
            pieChartView,
            chartCenterButton,
//            financialTitleLabel,
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
            $0.left.equalTo(safeAreaLayoutGuide).offset(20)
        }
        
        totalAssetsTitleLabel.snp.makeConstraints {
            $0.top.equalTo(mainWelcomeTitleLabel.snp.bottom).offset(20)
            $0.left.equalTo(safeAreaLayoutGuide).offset(20)
        }
        
        totalAssetsValueLabel.snp.makeConstraints {
            $0.top.equalTo(totalAssetsTitleLabel.snp.bottom).offset(20)
            $0.left.equalTo(safeAreaLayoutGuide).offset(20)
        }
        
        pieChartView.snp.makeConstraints {
            $0.top.equalTo(totalAssetsValueLabel.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(30)
            $0.height.equalTo(pieChartView.snp.width).multipliedBy(1.0)
        }
        
        chartCenterButton.snp.makeConstraints {
            $0.centerX.equalTo(pieChartView)
            $0.top.equalTo(pieChartView.snp.top).offset(120)
            $0.height.equalTo(40)
            $0.width.equalTo(80)
        }
        
//        financialTitleLabel.snp.makeConstraints {
//            $0.top.equalTo(pieChartView.snp.bottom).offset(40)
//            $0.left.equalTo(safeAreaLayoutGuide).offset(20)
//        }
//        
        financialScrollView.snp.makeConstraints {
            $0.top.equalTo(chartCenterButton.snp.bottom).offset(20)
            $0.height.equalTo(40)
            $0.left.right.equalToSuperview().offset(10)
        }
        
        financialHorizontalStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }
        
        benefitTitleLabel.snp.makeConstraints {
            $0.top.equalTo(financialScrollView.snp.bottom).offset(40)
            $0.left.equalTo(safeAreaLayoutGuide).offset(20)
        }
        
        benefitVerticalStackView.snp.makeConstraints {
            $0.top.equalTo(benefitTitleLabel.snp.bottom).offset(5)
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().offset(-20)
        }
    }
}
