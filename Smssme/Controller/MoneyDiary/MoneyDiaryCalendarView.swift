//
//  MoneyDiaryCalendarView.swift
//  Smssme
//
//  Created by KimRin on 8/28/24.
//

import UIKit

import SnapKit

class CalendarView: UIView {
    
    lazy var weekStackView = UIStackView()
    lazy var calendarCollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
                flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        collectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: CalendarCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func makeConstraints(){
        [
            weekStackView,
            calendarCollectionView
        ].forEach { self.addSubview($0) }
     
        self.weekStackView.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.horizontalEdges.equalTo(self.snp.horizontalEdges)
            $0.height.equalTo(18)
        }
        self.calendarCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.weekStackView.snp.bottom)
            $0.width.equalTo(self.snp.width)
            $0.height.equalTo(self.snp.width).multipliedBy(1.5)
            
        }
    }
}
