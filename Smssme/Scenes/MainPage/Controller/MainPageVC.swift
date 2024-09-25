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
    private let chartDataManager = ChartDataManager()
    private let assetsCoreDataManager = AssetsCoreDataManager()
    private let financialPlanManager = FinancialPlanManager.shared
    private let diaryCoreDataManager = DiaryCoreDataManager.shared
    var dataEntries: [PieChartDataEntry] = []
    
    //경제 지표
    lazy var stockIndexDataArray: [StockIndexData] = []
    
    
    //MARK: - Life cycle
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupStockData()
        
        setupWelcomeTitle()
        setupTableView()
        
    }
    
    override func loadView() {
        super.loadView()
        self.view = mainPageView
        setupCenterButtonEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        
        setupWelcomeTitle()
        setupCollectionView()
        setChart()
    }
    
    //MARK: - func
    private func setupCenterButtonEvent() {
        mainPageView.chartCenterButton.addTarget(self, action: #selector(editViewPush), for: .touchUpInside)
    }
    
    private func setupTableView() {
        mainPageView.benefitVerticalTableView.delegate = self
        mainPageView.benefitVerticalTableView.dataSource = self
        mainPageView.benefitVerticalTableView.register(BenefitVerticalCell.self, forCellReuseIdentifier: "BenefitVerticalCell")
        
        // UI setup
        mainPageView.benefitVerticalTableView.separatorStyle = .none
        mainPageView.benefitVerticalTableView.layer.cornerRadius = 22
        
        mainPageView.benefitVerticalTableView.layer.masksToBounds = false
        mainPageView.benefitVerticalTableView.layer.shadowColor = UIColor.black.cgColor
        mainPageView.benefitVerticalTableView.layer.shadowOpacity = 0.15
        mainPageView.benefitVerticalTableView.layer.shadowRadius = 10
        mainPageView.benefitVerticalTableView.layer.shadowOffset = CGSize(width: 0, height: 5)
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
    
    //MARK: - 경제지표 API 호출
    func setupStockData() {
        //날짜 포멧
        let dateFormatter = DateFormatter()
        
        fetchKOSPIData(idxNm: "코스피")
        fetchKOSPIData(idxNm: "코스닥")
        fetchSP500Last7Days()
        
        //MARK: - 코스피 데이터 가져오는 메서드
        func fetchKOSPIData(idxNm: String){
            //날짜 변환 및 날짜 구하기
            dateFormatter.dateFormat = "yyyyMMdd"
            
            // 오늘 날짜와 7일 전 날짜를 계산
            let today = Date()
            guard let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: today) else {
                print("코스피 7일 전 날짜 구하기 오류")
                return
            }
            
            let todayString = dateFormatter.string(from: today)
            let sevenDaysAgoString = dateFormatter.string(from: sevenDaysAgo)
            
            print("코스피 오늘 날짜: \(todayString)")
            print("코스피 일주일 전 날짜: \(sevenDaysAgoString)")
            
            guard let serviceKey = Bundle.main.object(forInfoDictionaryKey: "PUBLIC_DATA_API_KEY") as? String else {return}
            
            let endpoint = Endpoint(
                baseURL: "https://apis.data.go.kr",
                path: "/1160100/service/GetMarketIndexInfoService/getStockMarketIndex",
                queryParameters: [
                    "serviceKey": serviceKey,
                    "resultType": "json",
                    "idxNm": idxNm,
                    "beginBasDt": sevenDaysAgoString,
                    "endBasDt": todayString
                ]
            )
            

            
            NetworkManager.shared.fetch(endpoint: endpoint) { [weak self] (result: Result< KOSPIResponse, Error>) in
                
                guard let self = self else { return } // self가 nil일 경우 클로저를 종료
                
                switch result {
                case .success(let response):

                    let items = response.response.body.items.item
                    if let latestItem = items.max(by: {$0.basDt < $1.basDt}) {
                        print("가장 최신의 코스피 기준 날짜: \(latestItem.basDt)")
                        
                        let kospiItem = StockIndexData.convertKOSPIToStockIndex(kospiItem: latestItem)
  
                        self.stockIndexDataArray.append(kospiItem)

                        print("🌟 stockIndexDataArray의 갯수: \(self.stockIndexDataArray.count) /  \(self.stockIndexDataArray)")
      
                            DispatchQueue.main.async{
                                self.mainPageView.stockIndexcollectionView.reloadData()
                            }

                    } else {
                        print("가져온 코스피 데이터가 없습니다.")
                    }
                    
                case .failure(let error):
                    print("코스피 데이터 가져오기 실패 \(error)")
                }
            }
        }
        
        //MARK: - S&P500 데이터 가져오는 메서드
        func fetchSP500Last7Days() {
            
            //날짜 변환 및 날짜 구하기
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            // 오늘 날짜와 7일 전 날짜를 계산
            let today = Date()
            guard let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: today) else {
                print("S&P500 7일 전 날짜 구하기 오류")
                return
            }
            
            let todayString = dateFormatter.string(from: today)
            let sevenDaysAgoString = dateFormatter.string(from: sevenDaysAgo)
            
            guard let api_key = Bundle.main.object(forInfoDictionaryKey: "FRED_API_KEY") as? String else {return}
            
            // 오늘의 S&P 500 데이터를 가져오기 위한 URL 요청 구성
            let endpoint = Endpoint(
                baseURL: "https://api.stlouisfed.org",
                path: "/fred/series/observations",
                queryParameters: [
                    "series_id": "SP500",
                    "api_key": api_key,
                    "start_date": sevenDaysAgoString,
                    "end_date": todayString,
                    "file_type": "json",
                    "limit": "7",
                    "sort_order": "desc"
                ]
            )
            
            //NetworkManager를 통해 데이터 기져오기
            NetworkManager.shared.fetch(endpoint: endpoint) { [weak self] (result: Result<SP500Response, Error>) in
                switch result {
                case .success(let response):
                    print("거래 데이터를 가져오는데 성공했습니다.")
                    processSP500Data(response: response)
                    
                case .failure(let error):
                    print("거래 데이터를 가져오는데 실패했습니다:\n \(error.localizedDescription)")
                    
                }
            }
        }
        
        //MARK: - S&P500 가장 최근의 데이터 찾는 메서드
        func processSP500Data(response: SP500Response) {
            // 최근 7일간의 데이터를 역순으로 정렬 (desc로 요청했기 때문에 이미 정렬되어 있음)
            let observations = response.observations.sorted { $0.date > $1.date }
            
            // 최근 7일 중 가장 최신 데이터와 전날 데이터 추출
            guard observations.count > 1 else {
                print("최근 7일 동안 충분한 S&P 500 데이터가 없습니다.")
                return
            }
            
            // 최신 데이터와 그 전날 데이터를 가져옵니다
            let latestObservation = observations[0]
            let previousObservation = observations[1]
            
            let latestValueString = latestObservation.value
            guard let latestValue = Double(latestValueString) else {
                print("가장 최신 S&P 500 데이터를 숫자로 변환할 수 없습니다.")
                return
            }
            
            let previousValueString = previousObservation.value
            guard let previousValue = Double(previousValueString) else {
                print("전일 S&P 500 데이터를 숫자로 변환할 수 없습니다.")
                return
            }
            
            // 등락 포인트와 비율 계산
            let change = latestValue - previousValue
            let changePercentage = (change / previousValue) * 100
            
            // 가장 최신 S&P 500 지수
            let sp500ValueString = String(format: "%.2f", latestValue)
            
            // 전일 대비 등락 비율
            let changeRateString = String(format: "%.2f", changePercentage)
            
            // 전일 대비 등락 포인트
            let changePointString = String(format: "%.2f", change)
            
            let sp500Item = StockIndexData.convertSP500OToStockIndex(value: sp500ValueString, changeRate: changeRateString, changePoint: changePointString)
            
            self.stockIndexDataArray.append(sp500Item)
            
            
            DispatchQueue.main.async{
                self.mainPageView.stockIndexcollectionView.reloadData()
            }

            print("🌟 S&P500 - stockIndexDataArray의 갯수: \(self.stockIndexDataArray.count) /  \(self.stockIndexDataArray)")
        }
        
        //MARK: - 환율 데이터 가져오는 메서드
        
    }
    
}

//MARK: - 주요 경제 지표 API 데이터
extension MainPageVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func setupCollectionView() {
        mainPageView.stockIndexcollectionView.dataSource = self
        //        mainPageView.stockIndexcollectionView.delegate = self
    }
    
    //MARK: - UICollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stockIndexDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StockIndexCell.reuseIdentifier, for: indexPath) as! StockIndexCell
        
        // 배열에서 해당 데이터 가져오기
        let stockIndexData = stockIndexDataArray[indexPath.item]
        
        // 셀에 데이터 전달 및 라벨 표시
        cell.configure(stockIndexData: stockIndexData)
        
        return cell
    }
    
}


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

//MARK: - 청년혜택 총정리
extension MainPageVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
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
        
        let title = Array(Benefit.shared.benefitData.keys.sorted(by: >))[indexPath.row]
        cell.titleLabel.text = title
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        
        let imageName = "benefit\(indexPath.row + 1)"
        cell.cellIconView.image = UIImage(named: imageName)
        
        return cell
    }
}
