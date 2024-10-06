//
//  FutureGraphVC.swift
//  Smssme
//
//  Created by 전성진 on 9/26/24.
//

import DGCharts
import UIKit

class FutureGraphVC: UIViewController {
    private let futureGraphView: FutureGraphView = FutureGraphView()
    private let assetsCoreDataManager = AssetsCoreDataManager()
    private let financialPlanManager = FinancialPlanManager.shared
    private let diaryCoreDataManager = DiaryCoreDataManager.shared
    private let chartDataManager = ChartDataManager()
    private var firstFutureAssets: [Double] = []
    private var firstFutureSavings: [Double] = []
    private var secondFutureAssets: [Double] = []
    private var secondFuturePlanAssets: [Double] = []
    private var futureYears: [String] = []
    
    //MARK: - Life cycle
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = futureGraphView
        setupButton()
        setupTableView()
    }
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - func
    private func setupButton() {
        futureGraphView.firstView.calculateButton.addTarget(self, action: #selector(firtsCalculateButtonTapped), for: .touchUpInside)
        futureGraphView.secondView.calculateButton.addTarget(self, action: #selector(secondCalculateButtonTapped), for: .touchUpInside)
    }
    
    private func calculateFirstFutureGraph(currentAsset: Double, annualSavings: Double, interestRate: Double, years: Int) -> ([Double], [Double], [String]) {
        var futureAssetValues: [Double] = []
        var futureSavingsValues: [Double] = []
        var yearsArray: [String] = []
        
        let currentYear = Calendar.current.component(.year, from: Date())
        
        for n in 1...years {
            let futureValueAsset = currentAsset * pow(1 + interestRate, Double(n))
            futureAssetValues.append(futureValueAsset)
            
            let futureValueSavings = annualSavings * (pow(1 + interestRate, Double(n)) - 1) / interestRate
            futureSavingsValues.append(futureValueSavings)
            
            let yearString = String(currentYear + n).suffix(2)
            yearsArray.append(String(yearString))
        }
        
        futureYears = yearsArray
        
        return (futureAssetValues, futureSavingsValues, yearsArray)
    }
    
    // 2번째 탭 데이터 넣어주는용
    private func calculateSecondFutureGraph(currentAsset: Double, planAsset: Double, interestRate: Double, years: Int) -> ([Double], [Double], [String]) {
        var futureAssetValues: [Double] = []           // 현재 자산의 미래 가치 배열
        var futurePlanAssetValues: [Double] = []       // 목표 자산의 연간 저축액 배열
        var yearsArray: [String] = []                 // 연도 배열

        let today = Date()
        let oneYearAgo = Calendar.current.date(byAdding: .year, value: -1, to: today)!

        // diaryCoreDataManager를 통해 지난 1년간의 저축 데이터를 가져옴
        let savingsList = diaryCoreDataManager.diaryToMonthData(array: diaryCoreDataManager.fetchDiaries(from: oneYearAgo, to: today) ?? [])
        
        // 1년치 저축액 평균을 구해 연간 저축액으로 변환
        let annualSavings: Double = Double((savingsList.reduce(0) { $0 + Int($1.amount) } / savingsList.count) * 12)
        
        let currentYear = Calendar.current.component(.year, from: Date())
        
        // 각 연도별로 예상 자산 및 저축액을 계산
        for n in 1...years {
            // 현재 자산의 미래 가치 계산
            let futureValueAsset = currentAsset * pow(1 + interestRate, Double(n))
            futureAssetValues.append(futureValueAsset)

            // 연도 계산 (2자리수로 표현)
            let yearString = String(currentYear + n).suffix(2)
            yearsArray.append(String(yearString))
        }
        
        for n in stride(from: years - 1, through: 0, by: -1) {
            let futureAsset = planAsset / pow(1 + interestRate, Double(n))
            futurePlanAssetValues.append(futureAsset)
        }
        
        let denominator = (pow(1 + interestRate, Double(years)) - 1) / interestRate
        
        let futureAssetValue = futureAssetValues.last!
        
        let goalSavings = (planAsset - currentAsset) / denominator
        
        let currentMonthSaving = annualSavings / 12
        
        let goalMonthSaving = goalSavings / 12

        // futureYears 배열 업데이트 (이 값이 외부에서 사용될 가능성이 있으므로)
        futureYears = yearsArray

        // UI 업데이트 (2번째 탭의 레이블들 업데이트)
        futureGraphView.secondView.firstFutureAssetAmountLabel.text = "\(formattedCurrencyString(from: futureAssetValue)) 원"
        futureGraphView.secondView.firstSavingsAmountLabel.text = "\(formattedCurrencyString(from: annualSavings)) 원"
        futureGraphView.secondView.firstTotalAssetAmountLabel.text = "\(formattedCurrencyString(from: currentAsset)) 원"

        futureGraphView.secondView.secondFutureAssetAmountLabel.text = "\(formattedCurrencyString(from: planAsset)) 원"
        futureGraphView.secondView.secondSavingsAmountLabel.text = "\(formattedCurrencyString(from: goalSavings)) 원"
        futureGraphView.secondView.secondTotalAssetAmountLabel.text = "\(formattedCurrencyString(from: currentAsset)) 원"
        if goalMonthSaving - currentMonthSaving > 0 {
            futureGraphView.secondView.diagnosisInfoLabel.text = "목표금액을 위해서는 월 \(formattedCurrencyString(from: goalMonthSaving - currentMonthSaving)) (연 \(formattedCurrencyString(from: goalSavings - annualSavings)) 원) 원을 더 저축해야해요!"
        } else {
            futureGraphView.secondView.diagnosisInfoLabel.text = "현재 저축액으로 충분 합니다!"
        }
        
        return (futureAssetValues, futurePlanAssetValues, yearsArray)
    }
    
    private func updateFirstChartData(yearsArray: [String]) {
        var assetEntries: [BarChartDataEntry] = []
        var savingsEntries: [BarChartDataEntry] = []
        
        for (index, value) in firstFutureAssets.enumerated() {
            let entry = BarChartDataEntry(x: Double(index), y: value)
            assetEntries.append(entry)
        }
        
        for (index, value) in firstFutureSavings.enumerated() {
            let totalValue = value + firstFutureAssets[index]
            let entry = BarChartDataEntry(x: Double(index), y: totalValue)
            savingsEntries.append(entry)
        }
        
        let assetDataSet = BarChartDataSet(entries: assetEntries, label: "현재 자산의 미래가치")
        assetDataSet.colors = [UIColor.systemBlue.withAlphaComponent(1.0)]
        assetDataSet.drawValuesEnabled = false
        
        let savingsDataSet = BarChartDataSet(entries: savingsEntries, label: "저축액의 미래가치")
        savingsDataSet.colors = [UIColor.systemGreen.withAlphaComponent(1.0)]
        savingsDataSet.drawValuesEnabled = false
        
        let chartData = BarChartData(dataSets: [savingsDataSet, assetDataSet])
        futureGraphView.firstView.barChartView.data = chartData
        
        let yAxis = futureGraphView.firstView.barChartView.leftAxis
        yAxis.valueFormatter = DefaultAxisValueFormatter(block: { (value, axis) -> String in
            return "\(Int(value / 1_000_000))백만"
        })

        
        futureGraphView.firstView.barChartView.xAxis.valueFormatter = DefaultAxisValueFormatter(block: { (value, axis) in
            let index = Int(value)
            return "\(yearsArray[index])"
        })
        
        futureGraphView.firstView.barChartView.animate(yAxisDuration: 1.5, easingOption: .easeInOutQuad)
        
        futureGraphView.firstView.barChartView.notifyDataSetChanged()
    }
    
    private func updateSecondChartData(yearsArray: [String]) {
        var assetEntries: [BarChartDataEntry] = []
        var planAssetEntries: [BarChartDataEntry] = []
        
        for (index, value) in secondFutureAssets.enumerated() {
            let entry = BarChartDataEntry(x: Double(index), y: value)
            assetEntries.append(entry)
        }
        
        for (index, value) in secondFuturePlanAssets.enumerated() {
            let entry = BarChartDataEntry(x: Double(index), y: value)
            planAssetEntries.append(entry)
        }
        
        let assetDataSet = BarChartDataSet(entries: assetEntries, label: "현재추이 미래자산")
        assetDataSet.colors = [UIColor.systemBlue.withAlphaComponent(1.0)]
        assetDataSet.drawValuesEnabled = false
        
        let savingsDataSet = BarChartDataSet(entries: planAssetEntries, label: "목표 미래자산")
        savingsDataSet.colors = [UIColor.systemGreen.withAlphaComponent(1.0)]
        savingsDataSet.drawValuesEnabled = false
        
        // 데이터 세트 설정
        let chartData = BarChartData(dataSets: [assetDataSet, savingsDataSet])
        
        // 막대 너비, 그룹 간격 및 바 간격 설정
        let groupSpace = 0.2
        let barSpace = 0.05
        let barWidth = 0.3
        
        chartData.barWidth = barWidth // 막대 너비 설정
        
        // 차트에 데이터 설정
        futureGraphView.secondView.barChartView.data = chartData
        
        // x 축 값 최소 및 최대값 설정
        futureGraphView.secondView.barChartView.xAxis.axisMinimum = 0
        futureGraphView.secondView.barChartView.xAxis.axisMaximum = Double(yearsArray.count)
        
        // 데이터 그룹화 (X 좌표에 따라)
        chartData.groupBars(fromX: 0, groupSpace: groupSpace, barSpace: barSpace)
        
        // y 축 포맷 설정
        let yAxis = futureGraphView.secondView.barChartView.leftAxis
        yAxis.valueFormatter = DefaultAxisValueFormatter(block: { (value, axis) -> String in
            return "\(Int(value / 1_000_000))백만"
        })

        // x 축 포맷 설정
        futureGraphView.secondView.barChartView.xAxis.valueFormatter = DefaultAxisValueFormatter(block: { (value, axis) in
            let index = Int(value)
            return "\(yearsArray[index])"
        })
        
        // 애니메이션 설정
        futureGraphView.secondView.barChartView.animate(yAxisDuration: 1.5, easingOption: .easeInOutQuad)
        
        // 차트 업데이트
        futureGraphView.secondView.barChartView.notifyDataSetChanged()
    }
    
    func setupTableView() {
        futureGraphView.firstView.tableView.dataSource = self
        futureGraphView.firstView.tableView.delegate = self
        futureGraphView.firstView.tableView.register(FutureGraphCell.self, forCellReuseIdentifier: FutureGraphCell.identifier)
    }
    
    func formattedCurrencyString(from number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "" // 통화 기호를 없애고 싶다면 빈 문자열로 설정
        formatter.usesGroupingSeparator = true // 그룹 구분자 사용
        formatter.groupingSeparator = "," // 그룹 구분자를 콤마로 설정
        formatter.minimumFractionDigits = 0 // 소수점 이하 자리 수
        formatter.maximumFractionDigits = 0
        
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
    
    //MARK: - Objc
    @objc private func firtsCalculateButtonTapped() {
        let formatter = KoreanCurrencyFormatter.shared
        
        guard let assetText = futureGraphView.firstView.assetTextField.text, let asset = formatter.number(from: assetText),
              let savingsText = futureGraphView.firstView.savingsTextField.text, let savings = formatter.number(from: savingsText),
              let interestRateText = futureGraphView.firstView.interestRateTextField.text, let interestRate = Double(interestRateText) else {
            showAlert(message: "잘못된 입력입니다.", AlertTitle: "알림", buttonClickTitle: "확인")
            return
        }
        
        let interestRatePercentage = interestRate / 100
        let years = 20
        
        let (calculatedFutureAssets, calculatedFutureSavings, yearsArray) = calculateFirstFutureGraph(currentAsset: Double(asset), annualSavings: Double(savings), interestRate: interestRatePercentage, years: years)
        
        firstFutureAssets = calculatedFutureAssets
        firstFutureSavings = calculatedFutureSavings
        
        updateFirstChartData(yearsArray: yearsArray)
        
        futureGraphView.firstView.scrollView.isScrollEnabled = true
        futureGraphView.firstView.tableView.isHidden = false
        futureGraphView.firstView.tableView.reloadData()
    }
    
    @objc private func secondCalculateButtonTapped() {
        let formatter = KoreanCurrencyFormatter.shared
        let asset = chartDataManager.getBarChartTotalAssetsValue()
        
        guard let planSaving = formatter.number(from: futureGraphView.secondView.savingsTextField.text ?? "0") else { return }
        
        let interestRatePercentage = 0.0303
        let years = 20
        let futureAsset = asset * pow(1 + interestRatePercentage, Double(years))
        
        guard futureAsset < Double(planSaving) else {
            showAlert(message: "현재자산의 미래가치(\(formattedCurrencyString(from: futureAsset)) 원) 보다 큰 금액을 입력해야 합니다", AlertTitle: "알림", buttonClickTitle: "확인")
            return
        }
                
        let (calculatedFutureAssets, futurePlanAssetValues, yearsArray) = calculateSecondFutureGraph(currentAsset: asset, planAsset: Double(planSaving), interestRate: interestRatePercentage, years: years)
        
        secondFutureAssets = calculatedFutureAssets
        secondFuturePlanAssets = futurePlanAssetValues
        
        updateSecondChartData(yearsArray: yearsArray)
    }
}

// MARK: - UITableViewDataSource
extension FutureGraphVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return firstFutureAssets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FutureGraphCell.identifier, for: indexPath) as? FutureGraphCell else {
            return UITableViewCell()
        }
        
        cell.configure(year: futureYears[indexPath.item], asset: firstFutureAssets[indexPath.row], savings: firstFutureSavings[indexPath.row])
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FutureGraphVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
}
