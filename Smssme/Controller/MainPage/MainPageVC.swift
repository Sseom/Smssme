//
//  MainPageVC.swift
//  Smssme
//
//  Created by 전성진 on 8/28/24.
//

import UIKit
import DGCharts

class MainPageVC: UIViewController {
    private let mainPageView: MainPageView = MainPageView()
    var lastSelectedIndex: Int? = nil
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        self.view = mainPageView
        mainPageView.pieChartView.delegate = self
    }
//    // 터치 이벤트 처리
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let touch = touches.first {
//            let location = touch.location(in: mainPageView.pieChartView)
//            if isPointInCenter(location: location) {
//                print("중앙 텍스트가 클릭되었습니다.")
//                // 중앙 텍스트 클릭 시 수행할 동작
//            }
//        }
//    }
//    
//    private func isPointInCenter(location: CGPoint) -> Bool {
//        let center = CGPoint(x: mainPageView.pieChartView.bounds.width / 2, y: mainPageView.pieChartView.bounds.height / 2)
//        let radius = mainPageView.pieChartView.bounds.width / 4 // 중앙 영역의 반경
//        let distance = sqrt(pow(location.x - center.x, 2) + pow(location.y - center.y, 2))
//        return distance < radius
//    }
}

extension MainPageVC: ChartViewDelegate {
    // ChartViewDelegate 메서드
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if let lastIndex = lastSelectedIndex, lastIndex == Int(highlight.x) {
            // 같은 섹터를 다시 클릭했을 때
            mainPageView.pieChartView.highlightValues(nil)  // 하이라이트 해제
            lastSelectedIndex = nil
        } else {
            lastSelectedIndex = Int(highlight.x)
        }
    }
}
