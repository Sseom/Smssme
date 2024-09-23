//
//  MainPageVC.swift
//  Smssme
//
//  Created by 전성진 on 8/28/24.
//

import DGCharts
import FirebaseAuth
import SafariServices
import UIKit

class MainPageVC: UIViewController, UITableViewDelegate {
    private let mainPageView: MainPageView = MainPageView()
    private let chartDataManager = ChartDataManager()
    private let assetsCoreDataManager = AssetsCoreDataManager()
    private let financialPlanManager = FinancialPlanManager.shared
    private let diaryCoreDataManager = DiaryCoreDataManager.shared
    var dataEntries: [PieChartDataEntry] = []
    
    //경제 지표
    private var financialData: [FinancialData] = []

    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWelcomeTitle()
        setupTableView()
        view.backgroundColor = .white
    }
    
    override func loadView() {
        super.loadView()
        self.view = mainPageView
        setupCenterButtonEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupWelcomeTitle()
        
        self.navigationController?.isNavigationBarHidden = true
        
        setChart()
//        setupCollectionView()
    }
    
    private func setupCenterButtonEvent() {
        mainPageView.chartCenterButton.addTarget(self, action: #selector(editViewPush), for: .touchUpInside)
    }
    
    private func setupTableView() {
        mainPageView.benefitVerticalTableView.delegate = self
        mainPageView.benefitVerticalTableView.dataSource = self
        mainPageView.benefitVerticalTableView.register(BenefitVerticalCell.self, forCellReuseIdentifier: "BenefitVerticalCell")
    }
    
    private func setupWelcomeTitle() {
        // 현재 로그인한 사용자 정보
        if let uid = Auth.auth().currentUser?.uid {
            FirebaseFirestoreManager.shared.fetchUserData(uid: uid) { result in
                switch result {
                case .success(let data):
                    if let nickname = data["nickname"] as? String {
                        self.mainPageView.mainWelcomeTitleLabel.text = "환영합니다 \n\(nickname) 님"
                    } else {
                        print("닉네임을 찾을 수 없습니다.")
                    }
                case .failure(let error):
                    self.showAlert(message: "데이터를 가져오는 도중 오류 발생: \(error.localizedDescription)", AlertTitle: "에러발생", buttonClickTitle: "확인")
                }
            }
        } else {
            print("로그인 정보가 없습니다.")
        }
    }
    
    func setChart() {
        // 차트에서 표현할 데이터 리스트
        var assetsList = chartDataManager.assetsToChartData(array: assetsCoreDataManager.selectAllAssets())
        let financialPlan = chartDataManager.planToChartData(array: financialPlanManager.fetchAllFinancialPlans(), title: "플랜 자산")
        let diary = chartDataManager.diaryToChartData(array: diaryCoreDataManager.fetchDiaries())
        
        assetsList.append(financialPlan)
        assetsList.append(diary)
        assetsList.sort { $0.title! < $1.title! }
        
        let data = chartDataManager.pieChartPercentageData(array: assetsList)
        let entries = data.0
        let totalAmount = data.1
        
        let predefinedColors: [UIColor] = [
            UIColor(hex: "#3FB6DC"), // 청록색
            UIColor(hex: "#2DC76D"), // 녹색
            UIColor(hex: "#FF7052"), // 주황색
            UIColor(hex: "#FFC107"), // 노란색
            UIColor(hex: "#FF5722"), // 진한 주황색 계열
            UIColor(hex: "#8BC34A"), // 연한 녹색 계열
            UIColor(hex: "#673AB7"), // 보라색 계열
            UIColor(hex: "#9C27B0"), // 밝은 보라색 계열
            UIColor(hex: "#00BCD4"), // 하늘색 계열
            UIColor(hex: "#E91E63") // 분홍색 계열
        ]
        
        var dataSet: PieChartDataSet
        if entries.count != 0 {
            dataSet = PieChartDataSet(entries: entries, label: "")
            dataSet.valueFormatter = PercentageValueFormatter()
            
            // 미리 정의된 색상 배열을 섹터에 맞춰 순환하여 적용
            dataSet.colors = entries.enumerated().map { index, _ in
                return predefinedColors[index % predefinedColors.count]
            }
            
            dataSet.valueColors = dataSet.colors.map { _ in
                return .darkGray
            }
            mainPageView.chartCenterButton.setTitle("자산편집", for: .normal)
            mainPageView.pieChartView.alpha = 1.0
        } else {
            // 데이터 없을시 더미데이터
            let entries = [
                PieChartDataEntry(value: 40, label: "자동차"),
                PieChartDataEntry(value: 30, label: "부동산"),
                PieChartDataEntry(value: 20, label: "현금"),
                PieChartDataEntry(value: 10, label: "주식")
            ]
            
            dataSet = PieChartDataSet(entries: entries, label: "")
            dataSet.valueFormatter = PercentageValueFormatter()
            dataSet.colors = [
                    UIColor.lightGray,
                    UIColor.darkGray,
                    UIColor.gray,
                    UIColor.black
                ]
            dataSet.valueColors = dataSet.colors.map { _ in
                return .white
            }
            mainPageView.chartCenterButton.setTitle("등록된 자산이 없습니다.\n자산을 등록해 주세요", for: .normal)
            mainPageView.pieChartView.alpha = 0.5
        }
        let chartData = PieChartData(dataSet: dataSet)
        mainPageView.pieChartView.data = chartData
        mainPageView.totalAssetsValueLabel.text = "\(KoreanCurrencyFormatter.shared.string(from:(Int64(totalAmount)))) 원"
    }
    
    @objc func editViewPush() {
        navigationController?.pushViewController(AssetsListVC(), animated: true)
    }
}

//MARK: - 주요 경제 지표 API 데이터
//extension MainPageVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//    func setupCollectionView() {
//        mainPageView.stockIndexcollectionView.dataSource = self
//        mainPageView.stockIndexcollectionView.delegate = self
//        
//        mainPageView.stockIndexcollectionView.register(StockIndexCell.self, forCellWithReuseIdentifier: StockIndexCell.reuseIdentifier)
//        view.addSubview(mainPageView.stockIndexcollectionView)
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 4
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StockIndexCell.reuseIdentifier, for: indexPath) as! StockIndexCell
////        let item = kospiData[indexPath.item]
////        cell.configure(with: item)
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 150, height: 80) // 셀 크기
//    }
//    
//}

extension MainPageVC: UITabBarDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 사파리 연결
        let benefitKey = Array(Benefit.shared.benefitData.keys)[indexPath.row]
        guard let url = URL(string: Benefit.shared.benefitData[benefitKey] ?? "") else { return }
        let safariVC = SFSafariViewController(url: url)
        if let topController = UIApplication.shared.windows.first?.rootViewController {
            topController.present(safariVC, animated: true, completion: nil)
        }
    }
}

extension MainPageVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Benefit.shared.benefitData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BenefitVerticalCell", for: indexPath) as? BenefitVerticalCell else {
            return UITableViewCell()
        }
        
        let title = Array(Benefit.shared.benefitData.keys)[indexPath.row]
        cell.titleLabel.text = title
        cell.selectionStyle = .none
        
        return cell
    }
}

//extension MainPageVC: ChartViewDelegate {
//    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
//        if entry is PieChartDataEntry {
//            mainPageView.pieChartView.highlightValues(nil)
//            guard let index = dataEntries.firstIndex(of: entry as! PieChartDataEntry) else { return }
//            let uuid = uuids[index]
//            
//            let assetsEditVC = AssetsListVC()
//            assetsEditVC.uuid = uuid
//            
//            self.navigationController?.pushViewController(assetsEditVC, animated: true)
//        }
//    }
//}
