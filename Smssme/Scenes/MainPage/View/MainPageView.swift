import DGCharts
import SafariServices
import SnapKit
import UIKit

class MainPageView: UIView {
    // MARK: Properties
    var mainWelcomeTitleLabel = LargeTitleLabel().createLabel(with: "씀씀이의 방문을 \n환영합니다.", color: .black)
    private let totalAssetsTitleLabel = SmallTitleLabel().createLabel(with: "총 자산", color: .black)
    let totalAssetsValueLabel = LargeTitleLabel().createLabel(with: "0 원", color: .black)
    private let stockIndexTitleLabel = SmallTitleLabel().createLabel(with: "오늘의 주요 경제 지수", color: .black)
    private let benefitTitleLabel = SmallTitleLabel().createLabel(with: "2024 청년 혜택 총정리", color: .black)
    
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    //경제지표 컬렉션뷰
    lazy var stockIndexcollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.register(StockIndexCell.self, forCellWithReuseIdentifier: StockIndexCell.reuseIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 18 //좌우 줄간격
        layout.itemSize = CGSize(width: 120, height: 80)
        // 동적으로 cell의 크기를 계산할 때 성능을 높여 준다고 합니다.
        layout.estimatedItemSize = CGSize(width: 120, height: 80)
        
        return layout
    }
    
    let pieChartView: PieChartView = {
        let pieChartView = PieChartView()
        pieChartView.rotationEnabled = false
        pieChartView.legend.enabled = false
        pieChartView.isUserInteractionEnabled = false
        return pieChartView
    }()
    
    let chartCenterButton: UIButton = {
        let button = UIButton()
        button.setTitle("자산 추가", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    
    let benefitVerticalTableView = UITableView()
    
    // MARK: - View Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    //MARK: - 청년 혜택 총정리
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
            stockIndexTitleLabel,
            stockIndexcollectionView,
            benefitTitleLabel,
            benefitVerticalTableView
        ].forEach {
            contentView.addSubview($0)
        }
        
        //오토레이아웃
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
            $0.center.equalTo(pieChartView)
            $0.height.equalTo(120)
            $0.width.equalTo(120)
        }
        
        stockIndexTitleLabel.snp.makeConstraints {
            $0.top.equalTo(pieChartView.snp.bottom).offset(20)
            $0.left.equalTo(safeAreaLayoutGuide).offset(20)
        }
        
        stockIndexcollectionView.snp.makeConstraints {
            $0.top.equalTo(stockIndexTitleLabel.snp.bottom).offset(10)
            $0.height.equalTo(80)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview()
        }
        
        benefitTitleLabel.snp.makeConstraints {
            $0.top.equalTo(stockIndexcollectionView.snp.bottom).offset(40)
            $0.left.equalTo(safeAreaLayoutGuide).offset(20)
        }
        
        benefitVerticalTableView.snp.makeConstraints {
            $0.top.equalTo(benefitTitleLabel.snp.bottom).offset(20)
            $0.height.equalTo(400)
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().offset(-40)
        }
    }
}
