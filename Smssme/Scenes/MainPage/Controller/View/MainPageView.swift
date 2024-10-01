import DGCharts
import SafariServices
import SnapKit
import UIKit

class MainPageView: UIView {
    // MARK: Properties
    var mainWelcomeTitleLabel = LabelFactory.titleLabel()
        .setText("씀씀이의 방문을 \n환영합니다.")
        .build()
    
    private let totalAssetsTitleLabel = LabelFactory.subTitleLabel()
        .setFont(.boldSystemFont(ofSize: 18))
        .setColor(.bodyGray)
        .setText("총 자산")
        .build()
    
    let totalAssetsValueLabel = LabelFactory.titleLabel()
        .setText("0 원")
        .build()
    
    private let stockIndexTitleLabel = LabelFactory.titleLabel()
        .setFont(.boldSystemFont(ofSize: 18))
        .setText("주요 경제 지수")
        .build()
    
    var stockIndexDateLabel = LabelFactory.captionLabel()
        .setColor(.disableGray)
        .setAlign(.right)
        .build()
    
    private let benefitTitleLabel = LabelFactory.titleLabel()
        .setFont(.boldSystemFont(ofSize: 18))
        .setText("2024 청년 혜택 총정리")
        .build()

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
        layout.minimumLineSpacing = 8
        
        // 화면 너비에 따라 셀 너비 동적으로 대응하게
        let screenWidth = UIScreen.main.bounds.width
        let contentInset: CGFloat = 32
        let spaceBetweenItems: CGFloat = 16
        let availableWidth = screenWidth - contentInset - spaceBetweenItems
        // 제공 항목이 3개 = 3등분하여 소수점 아래 버림
        let itemWidth = (availableWidth / 3).rounded(.down)
        
        layout.itemSize = CGSize(width: itemWidth, height: 80)
        layout.estimatedItemSize = CGSize(width: itemWidth, height: 80)
        
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
        button.setTitle("자산목록 보기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        return button
    }()
  
    let benefitVerticalTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 22
        
        tableView.layer.masksToBounds = false
        tableView.layer.shadowColor = UIColor.black.cgColor
        tableView.layer.shadowOpacity = 0.15
        tableView.layer.shadowRadius = 10
        tableView.layer.shadowOffset = CGSize(width: 0, height: 5)
        return tableView
    }()
    
    // MARK: - View Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    // MARK: - 청년 혜택 총정리
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
            stockIndexDateLabel,
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
        }
        
        mainWelcomeTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalTo(safeAreaLayoutGuide).offset(20)
        }
        
        totalAssetsTitleLabel.snp.makeConstraints {
            $0.top.equalTo(mainWelcomeTitleLabel.snp.bottom).offset(24)
            $0.left.equalTo(safeAreaLayoutGuide).offset(20)
        }
        
        totalAssetsValueLabel.snp.makeConstraints {
            $0.top.equalTo(totalAssetsTitleLabel.snp.bottom).offset(8)
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
            $0.top.equalTo(pieChartView.snp.bottom).offset(28)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(20)
            $0.width.equalTo(100)
        }
        
        stockIndexDateLabel.snp.makeConstraints {
            $0.centerY.equalTo(stockIndexTitleLabel.snp.centerY)
            $0.trailing.equalTo(safeAreaLayoutGuide).offset(-20)
            $0.width.equalTo(150)
        }
        
        stockIndexcollectionView.snp.makeConstraints {
            $0.top.equalTo(stockIndexTitleLabel.snp.bottom).offset(16)
            $0.height.equalTo(80)
            $0.horizontalEdges.equalToSuperview().inset(16)
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
