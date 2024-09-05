//
//  FinancialPlanCurrentPlanCell.swift
//  Smssme
//
//  Created by 임혜정 on 9/1/24.
//

import SnapKit
import UIKit

class FinancialPlanCurrentPlanCell: UICollectionViewCell {
    private var repository: FinancialPlanRepository?
    static let ID = "FinancialPlanCurrentPlanCell"
    private let graphBarArea = ProgressBarView()
    
    private let currentPlanTitlaLabel = ContentLabel().createLabel(with: "임시플랜", color: UIColor.gray)
    private let completionRateLabel = ContentLabel().createLabel(with: "", color: UIColor.gray)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [currentPlanTitlaLabel, completionRateLabel, graphBarArea].forEach {
            contentView.addSubview($0)
        }
        
        currentPlanTitlaLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        completionRateLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-10)
        }
        
        graphBarArea.snp.makeConstraints {
            $0.top.equalTo(currentPlanTitlaLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(0)
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.equalTo(20)
        }
    }
    
    func configure(item: FinancialPlan, repository: FinancialPlanRepository) {
        self.repository = repository
        currentPlanTitlaLabel.text = item.title
        let completionRate = calculateCompletionRate(plan: item)
        completionRateLabel.text = "달성률 \(Int(completionRate * 100))%"
        graphBarArea.setProgress(CGFloat(completionRate))
        
    }
    
    private func calculateCompletionRate(plan: FinancialPlan) -> Double {
        guard plan.amount > 0 else { return 0 }
        return Double(plan.deposit) / Double(plan.amount)
    }
}

// MARK: - 그래프막대 뷰, 변경사항이 있을 수 있어 변경가능성 없는 부분과 분리해둠
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
        view.layer.cornerRadius = 10
        return view
    }()
    
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
    
    func setProgress(_ progress: CGFloat) {
        DispatchQueue.main.async {
            self.layoutIfNeeded()
            let targetProgress = min(max(progress, 0), 1)
            UIView.animate(withDuration: 0.9, delay: 0, options: [.curveEaseInOut], animations: {
                self.progressWidthConstraint?.update(offset: self.bounds.width * targetProgress)
                self.layoutIfNeeded()
            }, completion: nil)
        }
    }
}
