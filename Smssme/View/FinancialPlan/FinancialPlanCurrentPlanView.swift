//
//  FinancialPlanCurrentPlanView.swift
//  Smssme
//
//  Created by 임혜정 on 8/29/24.
//

import SnapKit
import UIKit

final class FinancialPlanCurrentPlanView: UIView {
    private let progressBar = ProgressBarView()
    
    private let currentPlanTitle = LargeTitleLabel().createLabel(with: "진행중인 자산플랜", color: .black)
    
    private let graphStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.layer.borderColor = UIColor.green.cgColor
        stackView.layer.borderWidth = 1
        return stackView
    }()
    
    private lazy var addPlanButton = ActionButton().createButton(text: "플랜 추가", color: UIColor.blue, textColor: UIColor.white, method: FinancialPlanCreateVC().confirmButtomTapped)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        calculateGraphValues()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func graphUI(_ progressBar: ProgressBarView) {
        addSubview(progressBar)  // progressBar를 MainView에 추가
        backgroundColor = .white  // 배경색 설정
        
        progressBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(200)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(300)
            $0.height.equalTo(20)
        }
    }
    
    
    private func setupUI() {
        [currentPlanTitle, addPlanButton].forEach {
            addSubview($0)
        }
        
        currentPlanTitle.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.equalToSuperview().offset(20)
        }
        
        //        goalGraphArea.snp.makeConstraints {
        //            $0.top.equalTo(currentPlanTitle.snp.bottom).offset(20)
        //            $0.width.height.equalTo(300)
        //            $0.centerX.equalToSuperview()
        //        }
        
        addPlanButton.snp.makeConstraints {
            $0.top.equalTo(currentPlanTitle.snp.bottom).offset(40)
            $0.width.equalTo(80)
            $0.height.equalTo(40)
            $0.centerX.equalToSuperview()
        }
    }
    
    struct GraphValue {
        static func 초기값(_ 목표금액: CGFloat, _ 저축금액: CGFloat) -> CGFloat {
            return min(저축금액 / 목표금액, 1.0)
        }
    }
    
    func calculateGraphValues() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            print("\(GraphValue.초기값(5000, 3240))")
            self.progressBar.progress = GraphValue.초기값(5000, 3240)
        }
    }
}




class ProgressBarView: UIView {
    private var progressWidthConstraint: Constraint?
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private let progressView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 10
        return view
    }()
    
    var progress: CGFloat = 0 {
        didSet {
            updateProgress()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        [backgroundView, progressView].forEach {
            addSubview($0)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        progressView.snp.makeConstraints {
            $0.top.bottom.left.equalToSuperview()
            self.progressWidthConstraint = $0.width.equalTo(0).constraint
        }
    }
    
    private func updateProgress() {
        layoutIfNeeded()  // 레이아웃 즉시 업데이트
        UIView.animate(withDuration: 0.5) {
            self.progressWidthConstraint?.update(offset: self.bounds.width * self.progress)
            self.layoutIfNeeded()
        }
    }
}
