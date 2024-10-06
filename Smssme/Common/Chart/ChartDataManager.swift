//
//  ChartDataManager.swift
//  Smssme
//
//  Created by 전성진 on 9/18/24.
//

import DGCharts
import Foundation

class ChartDataManager {
    private let assetsCoreDataManager = AssetsCoreDataManager()
    private let financialPlanManager = FinancialPlanManager.shared
    private let diaryCoreDataManager = DiaryCoreDataManager.shared
    
    func pieChartPercentageData(array: [ChartData]) -> ([PieChartDataEntry], Double) {
        let totalAmount = Double(array.reduce(0) { $0 + Double($1.amount) })
        
        let chartArray = array.map {
            return PieChartDataEntry(value: ((Double($0.amount) / totalAmount) * 100), label: "\($0.title ?? "")")
        }
        
        return (chartArray, totalAmount)
    }
    
    // FIXME: 제네릭 말고 다형성으로 바꿔보자
    func chartDataMapping<T: ChartDataConvertible>(array: [T]) -> [ChartData] {
        return array.map {
            ChartData(amount: $0.amount, title: $0.title)
        }
    }
    
    func chartTotalDataMapping<T: ChartDataConvertible>(array: [T], title: String) -> ChartData {
        let amount = array.reduce(0) { $0 + Double($1.amount) }
        
        return ChartData(amount: Int64(amount), title: title)
    }
    
    func planToChartData(array: [FinancialPlan], title: String) -> ChartData {
        let amount = array.reduce(0) { $0 + Double($1.deposit) }
        
        return ChartData(amount: Int64(amount), title: title)
    }
    
    // Assets을 ChartData로 변환
    func assetsToChartData(array: [Assets]) -> [ChartData] {
        let groupedAssets = Dictionary(grouping: array) { $0.category ?? "기타" }
        
        let chartDataArray = groupedAssets.map { category, assets in
            let totalAmount = assets.reduce(0) { $0 + $1.amount }
            return ChartData(amount: totalAmount, title: category)
        }
        
        return chartDataArray
    }
    
    // 전체 순수익 계산
    func diaryToChartData(array: [Diary]) -> ChartData {
        let totalIncome = array.filter { $0.statement }.reduce(0) { $0 + $1.amount }
        let totalExpense = array.filter { !$0.statement }.reduce(0) { $0 + $1.amount }
        let netIncome = totalIncome - totalExpense
        
        return ChartData(amount: netIncome, title: "현금 자산")
    }
    
    func getBarChartTotalAssetsValue() -> Double {
        let assets = assetsCoreDataManager.selectAllAssets().reduce(0) {
            $0 + Double($1.amount)
        }
        let financialPlan = financialPlanManager.fetchAllFinancialPlans().reduce(0) {
            $0 + Double($1.deposit)
        }
        let diaryList = diaryCoreDataManager.fetchAllDiaries()
        
        let diary = diaryList.filter { $0.statement }.reduce(0) { $0 + Double($1.amount) } - diaryList.filter { !$0.statement }.reduce(0) { $0 + Double($1.amount) }
        
        return assets + financialPlan + diary
    }
    
    func mainAssetsData<T: ChartDataConvertible>(array: [[T]]) -> ([PieChartDataEntry], Double) {
        var chartArray: [PieChartDataEntry] = []
        let totalAmount = Double(array.flatMap { $0 }.reduce(0) { $0 + Double($1.amount) })
        
        array.forEach {
            $0.forEach {
                chartArray.append(PieChartDataEntry(value: ((Double($0.amount) / totalAmount) * 100), label: "\($0.title ?? "")"))
            }
        }
        return (chartArray, totalAmount)
    }

}
