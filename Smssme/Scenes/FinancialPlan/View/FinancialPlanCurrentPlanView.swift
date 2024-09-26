//
//  FinancialPlanCurrentPlanView.swift
//  Smssme
//
//  Created by 임혜정 on 8/29/24.
//

import SnapKit
import UIKit

final class FinancialPlanCurrentPlanView: UIView {
    private let currentPlanTitle = LabelFactory.titleLabel()
        .setText("진행중인 자산플랜")
        .build()
    
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
    
    let completePlanButton = ButtonFactory.fillButton()
        .setTitle("완료된 플랜")
        .setTitleColor(.white)
        .build()

    let addPlanButton = ButtonFactory.clearButton()
        .setTitle("새로운 플랜")
        .build()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [currentPlanTitle, 
         currentPlanCollectionView,
         completePlanButton,
         addPlanButton].forEach {
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
        
        completePlanButton.snp.makeConstraints {
            $0.top.equalTo(currentPlanCollectionView.snp.bottom).offset(24)
            $0.width.equalTo(100)
            $0.height.equalTo(40)
            $0.leading.equalToSuperview().offset(80)
        }
        
        addPlanButton.snp.makeConstraints {
            $0.top.equalTo(currentPlanCollectionView.snp.bottom).offset(24)
            $0.width.equalTo(100)
            $0.height.equalTo(40)
            $0.trailing.equalToSuperview().offset(-80)
        }
    }
}
