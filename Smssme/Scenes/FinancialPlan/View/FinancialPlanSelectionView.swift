//
//  FinancialPlanSelectionView.swift
//  Smssme
//
//  Created by 임혜정 on 8/27/24.
//

import SnapKit
import UIKit

final class FinancialPlanSelectionView: UIView {
    private let title = LabelFactory.titleLabel()
        .setText("재무 목표 플랜")
        .build()

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.register(FinancialPlanCell.self, forCellWithReuseIdentifier: FinancialPlanCell.ID)
        collectionView.backgroundColor = UIColor(hex: "#e9f3fd")
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor(hex: "#e9f3fd")
            TabBarController().tabBarController?.tabBar.backgroundColor = .white
        
        [
            title,
            collectionView
        ].forEach {
            addSubview($0)
        }
        
        title.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            $0.leading.equalTo(20)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(snp.bottom)
        }
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 24, bottom: 24, right: 24)
        
        let totalSpacing = layout.minimumInteritemSpacing + layout.sectionInset.left + layout.sectionInset.right
        let itemWidth = (UIScreen.main.bounds.width - totalSpacing) / 2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.3)
        return layout
    }
}

