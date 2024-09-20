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

class MainPageVC: UIViewController {
    private let mainPageView: MainPageView = MainPageView()
    private let assetsCoreDataManager = AssetsCoreDataManager()
    var dataEntries: [PieChartDataEntry] = []
    var uuids: [UUID?] = []
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func loadView() {
        super.loadView()
        self.view = mainPageView
        setupCenterButtonEvent()
        setChartData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupWelcomeTitle()
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setupCenterButtonEvent() {
        mainPageView.chartCenterButton.addTarget(self, action: #selector(editViewPush), for: .touchUpInside)
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
    
    private func setChart() {
//        mainPageView.pieChartView.delegate = self
        var dataSet: PieChartDataSet
        if dataEntries.count != 0 {
            dataSet = PieChartDataSet(entries: dataEntries, label: "")
            dataSet.valueFormatter = PercentageValueFormatter()
            dataSet.colors = dataEntries.map { _ in
                return UIColor(red: CGFloat.random(in: 0.5...1),
                               green: CGFloat.random(in: 0.5...1),
                               blue: CGFloat.random(in: 0.5...1),
                               alpha: 1.0)
            }
            dataSet.valueColors = dataSet.colors.map { _ in
                return .darkGray
            }
            mainPageView.chartCenterButton.setTitle("자산편집", for: .normal)
            mainPageView.pieChartView.alpha = 1.0
        } else {
            // 데이터 없을시 더미데이터
            let dataEntries = [
                PieChartDataEntry(value: 40, label: "자동차"),
                PieChartDataEntry(value: 30, label: "부동산"),
                PieChartDataEntry(value: 20, label: "현금"),
                PieChartDataEntry(value: 10, label: "주식")
            ]
            
            dataSet = PieChartDataSet(entries: dataEntries, label: "")
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
        let data = PieChartData(dataSet: dataSet)
        mainPageView.pieChartView.data = data
    }
    
    func setChartData() {
        let assestsList: [Assets] = assetsCoreDataManager.selectAllAssets()
        
        let totalAmount = assestsList.reduce(0) { $0 + $1.amount }
        
        dataEntries = assestsList.map {
            return PieChartDataEntry(value: ((Double($0.amount) / Double(totalAmount)) * 100), label: "\($0.title ?? "")")
        }
        
        uuids = assetsCoreDataManager.selectAllAssets().map {
            $0.key
        }
        mainPageView.totalAssetsValueLabel.text = "\(KoreanCurrencyFormatter.shared.string(from:(Int64(totalAmount)))) 원"
        
        setChart()
    }
    
    @objc func editViewPush() {
        navigationController?.pushViewController(AssetsListVC(), animated: true)
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
