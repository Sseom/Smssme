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
    }
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - func
    
    func setChart() {
        
    }
}
