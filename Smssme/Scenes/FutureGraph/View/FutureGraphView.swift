//
//  FutureGraphView.swift
//  Smssme
//
//  Created by 전성진 on 9/26/24.
//

import DGCharts
import SnapKit
import UIKit

class FutureGraphView: UIView {
    // MARK: Properties
    private let titleLabel = LabelFactory.titleLabel()
        .setText("내가 만들어보는 자산 그래프")
        .setAlign(.center)
        .build()
    
    let firstView = FutureGraphFirstView()
    let secondView = FutureGraphSecondView()
    
    lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["내가 만든 그래프", "미래자산 그래프"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentChange(segment:)), for: .valueChanged)
        return segmentedControl
    }()

    // MARK: - View Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        keyboardTouchEvent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func viewChange(index: Int) {
        for (indexNum, value) in [firstView, secondView].enumerated() {
            if indexNum == index {
                value.isHidden = false
            } else {
                value.isHidden = true
            }
        }
    }
    
    private func keyboardTouchEvent() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.touch))
        
//        [firstView, secondView].forEach {
//            $0.addGestureRecognizer(recognizer)
//        }
        
        self.addGestureRecognizer(recognizer)

    }
    
    private func setupUI() {
        [
         segmentedControl,
         firstView,
         secondView
        ].forEach {
            self.addSubview($0)
        }
        
        segmentedControl.snp.makeConstraints {
            $0.top.left.right.equalTo(self.safeAreaLayoutGuide).inset(15)
            $0.height.equalTo(30)
        }
        
        [
         firstView,
         secondView
        ].forEach {
            $0.snp.makeConstraints {
                $0.top.equalTo(segmentedControl.snp.bottom)
                $0.left.right.bottom.equalTo(self.safeAreaLayoutGuide)
            }
        }
    }
    
    //MARK: - @objc
    // 빈 화면 터치 시 키보드 내려감
    @objc func touch() {
        self.endEditing(true)
    }

    @objc func segmentChange(segment: UISegmentedControl) {
        viewChange(index: segment.selectedSegmentIndex)
        //        print("뷰 바뀜")
    }
}
