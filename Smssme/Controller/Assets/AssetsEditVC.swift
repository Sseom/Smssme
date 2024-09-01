//
//  AssetsEditVC.swift
//  Smssme
//
//  Created by 전성진 on 9/2/24.
//

import UIKit

class AssetsEditVC: UIViewController {
    //MARK: - Properties
    private let assetsEditView: AssetsEditView = AssetsEditView()
    
    // MARK: - ViewController Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        self.view = assetsEditView
    }
    
    // MARK: - Method
    
    // MARK: - Private Method
    //    private func setupSegmentEvent() {
    //        moneyDiaryEditView
    //    }
    
    // MARK: - Objc

}
