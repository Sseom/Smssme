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
    private let chartDataManager = ChartDataManager()
    private var futureAssets: [Double] = []
    private var futureSavings: [Double] = []
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
        futureGraphView.calculateButton.addTarget(self, action: #selector(calculateButtonTapped), for: .touchUpInside)
    }
    
    private func calculateFutureGraph(currentAsset: Double, annualSavings: Double, interestRate: Double, years: Int) -> ([Double], [Double], [String]) {
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
    
    private func updateChartData(yearsArray: [String]) {
        var assetEntries: [BarChartDataEntry] = []
        var savingsEntries: [BarChartDataEntry] = []
        
        for (index, value) in futureAssets.enumerated() {
            let entry = BarChartDataEntry(x: Double(index), y: value)
            assetEntries.append(entry)
        }
        
        for (index, value) in futureSavings.enumerated() {
            let totalValue = value + futureAssets[index]
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
        futureGraphView.barChartView.data = chartData
        
        let yAxis = futureGraphView.barChartView.leftAxis
        yAxis.valueFormatter = DefaultAxisValueFormatter(block: { (value, axis) -> String in
            return "\(Int(value / 1_000_000))백만"
        })

        
        futureGraphView.barChartView.xAxis.valueFormatter = DefaultAxisValueFormatter(block: { (value, axis) in
            let index = Int(value)
            return "\(yearsArray[index])"
        })
        
        futureGraphView.barChartView.animate(yAxisDuration: 1.5, easingOption: .easeInOutQuad)
        
        futureGraphView.barChartView.notifyDataSetChanged()
    }
    
    func setupTableView() {
        futureGraphView.tableView.dataSource = self
        futureGraphView.tableView.delegate = self
        futureGraphView.tableView.register(FutureGraphCell.self, forCellReuseIdentifier: FutureGraphCell.identifier)
    }
    
    //MARK: - Objc
    @objc private func calculateButtonTapped() {
        let formatter = KoreanCurrencyFormatter.shared
        
        guard let assetText = futureGraphView.assetTextField.text, let asset = formatter.number(from: assetText),
              let savingsText = futureGraphView.savingsTextField.text, let savings = formatter.number(from: savingsText),
              let interestRateText = futureGraphView.interestRateTextField.text, let interestRate = Double(interestRateText) else {
            showAlert(message: "잘못된 입력입니다.", AlertTitle: "알림", buttonClickTitle: "확인")
            return
        }
        
        let interestRatePercentage = interestRate / 100
        let years = 20
        
        let (calculatedFutureAssets, calculatedFutureSavings, yearsArray) = calculateFutureGraph(currentAsset: Double(asset), annualSavings: Double(savings), interestRate: interestRatePercentage, years: years)
        
        futureAssets = calculatedFutureAssets
        futureSavings = calculatedFutureSavings
        
        updateChartData(yearsArray: yearsArray)
        
        futureGraphView.scrollView.isScrollEnabled = true
        futureGraphView.tableView.isHidden = false
        futureGraphView.tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension FutureGraphVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return futureAssets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FutureGraphCell.identifier, for: indexPath) as? FutureGraphCell else {
            return UITableViewCell()
        }
        
        cell.configure(year: futureYears[indexPath.item], asset: futureAssets[indexPath.row], savings: futureSavings[indexPath.row])
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FutureGraphVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
}
