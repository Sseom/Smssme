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
    private let progressBar2 = ProgressBarView()
    private let progressBar3 = ProgressBarView()
    
    private let currentPlanTitle = LargeTitleLabel().createLabel(with: "진행중인 자산플랜", color: .black)
    
    private let graphStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let currentPlanDetailLabel = ContentLabel().createLabel(with: "웨딩플랜", color: .gray)
    
    private let currentPlanDetailLabel2 = ContentLabel().createLabel(with: "더미플랜", color: .gray)
    
    private let currentPlanDetailLabel3 = ContentLabel().createLabel(with: "더미플랜", color: .gray)
    
    var onAddPlanButtonTapped: (() -> Void)?
    private lazy var addPlanButton = ActionButton().createButton(text: "플랜 추가", color: UIColor.blue, textColor: UIColor.white, method: { [weak self] in
        self?.onAddPlanButtonTapped?()
    })
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [currentPlanTitle, graphStackView, addPlanButton].forEach {
            addSubview($0)
        }
        
        currentPlanTitle.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.equalToSuperview().offset(20)
        }
        
        graphStackView.snp.makeConstraints {
            $0.top.equalTo(currentPlanTitle.snp.bottom).offset(20)
            $0.width.equalTo(300)
            $0.height.equalTo(250)
            $0.centerX.equalToSuperview()
        }
        
        addPlanButton.snp.makeConstraints {
            $0.top.equalTo(graphStackView.snp.bottom).offset(40)
            $0.width.equalTo(80)
            $0.height.equalTo(40)
            $0.centerX.equalToSuperview()
        }
        
        setupGraphStackView()
    }
    
    private func setupGraphStackView() {
        [currentPlanDetailLabel, progressBar, currentPlanDetailLabel2, progressBar2,  currentPlanDetailLabel3, progressBar3].forEach {
            graphStackView.addArrangedSubview($0)
        }
        
        currentPlanDetailLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        progressBar.snp.makeConstraints {
            $0.top.equalTo(currentPlanDetailLabel.snp.bottom).offset(20)
            $0.width.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        currentPlanDetailLabel2.snp.makeConstraints {
            $0.top.equalTo(progressBar.snp.bottom).offset(30)
            $0.leading.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        progressBar2.snp.makeConstraints {
            $0.top.equalTo(currentPlanDetailLabel2.snp.bottom).offset(20)
            $0.width.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        currentPlanDetailLabel3.snp.makeConstraints {
            $0.top.equalTo(progressBar2.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        progressBar3.snp.makeConstraints {
            $0.top.equalTo(currentPlanDetailLabel.snp.bottom).offset(40)
            $0.width.equalToSuperview()
            $0.height.equalTo(20)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        calculateGraphValues()
    }
    
    // 테스트용, 성공하면 분리 예정 한글명 수정
    struct GraphValue {
        static func 초기값(_ 목표금액: CGFloat, _ 저축금액: CGFloat) -> CGFloat {
            return min(저축금액 / 목표금액, 1.0)
        }
    }
    
//    func calculateGraphValues() { 애니메이션을 위한 비동기 처리때문에 레이아웃이 자꾸 흔들림
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            print("\(GraphValue.초기값(5000, 3240))")
//            self.progressBar.progress = GraphValue.초기값(5000, 3240)
//            self.progressBar2.progress = GraphValue.초기값(5000, 2500)
//            self.progressBar3.progress = GraphValue.초기값(5000, 4500)
//        }
//        
//    }
    func calculateGraphValues() {
        self.progressBar.progress = 0
        self.progressBar2.progress = 0
        self.progressBar3.progress = 0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let progress1 = GraphValue.초기값(5000, 3240)
            let progress2 = GraphValue.초기값(5000, 2500)
            let progress3 = GraphValue.초기값(5000, 4500)
            
            UIView.animate(withDuration: 0.9) {
                self.progressBar.progress = progress1
                self.progressBar2.progress = progress2
                self.progressBar3.progress = progress3
            }
            
            print("디버깅용\(progress1), \(progress2), \(progress3)")
        }
    }
    
    
}


// 파일 분리 예정
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
        UIView.animate(withDuration: 0.9) {
            self.progressWidthConstraint?.update(offset: self.bounds.width * self.progress)
            self.layoutIfNeeded()
        }
    }
}
