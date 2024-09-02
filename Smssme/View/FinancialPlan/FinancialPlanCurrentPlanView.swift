//
//  FinancialPlanCurrentPlanView.swift
//  Smssme
//
//  Created by 임혜정 on 8/29/24.
//

import SnapKit
import UIKit

final class FinancialPlanCurrentPlanView: UIView {
    private let currentPlanTitle = LargeTitleLabel().createLabel(with: "진행중인 자산플랜", color: .black)
    
    lazy var currentPlanCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.backgroundColor = .white
        collectionView.register(FinancialPlanCurrentPlanCell.self, forCellWithReuseIdentifier: FinancialPlanCurrentPlanCell.ID)
        return collectionView
    }()
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 0)
        
        let itemWidth = UIScreen.main.bounds.width - 40
        layout.itemSize = CGSize(width: itemWidth, height: 80)
        
        return layout
    }
    
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
        [currentPlanTitle, currentPlanCollectionView, addPlanButton].forEach {
            addSubview($0)
        }
        
        currentPlanTitle.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.equalToSuperview().offset(20)
        }
        
        currentPlanCollectionView.snp.makeConstraints {
            $0.top.equalTo(currentPlanTitle.snp.bottom).offset(40)
            $0.height.equalTo(450)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
            $0.centerX.equalToSuperview()
        }
        
        addPlanButton.snp.makeConstraints {
            $0.top.equalTo(currentPlanCollectionView.snp.bottom).offset(40)
            $0.width.equalTo(80)
            $0.height.equalTo(40)
            $0.centerX.equalToSuperview()
        }
    }
}
