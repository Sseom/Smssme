//
//  MainPageVC.swift
//  Smssme
//
//  Created by 전성진 on 8/28/24.
//

import UIKit

class MainPageVC: UIViewController {
    private let mainPageView: MainPageView = MainPageView()
    
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
    }
}
