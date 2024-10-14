// DailyTransactionView.swift
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class DailyTransactionView: UIView {
    let dailyIncome: UILabel = SmallTitleLabel().createLabel(with: "income", color: .blue)
    let dailyExpense: UILabel = SmallTitleLabel().createLabel(with: "expense", color: .red)

    lazy var listCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10 // 셀 간 세로 간격
        layout.minimumInteritemSpacing = 10 // 셀 간 가로 간격
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) // 섹션 인셋 설정
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(DailyTransactionCell.self, forCellWithReuseIdentifier: DailyTransactionCell.reuseIdentifier) // 셀 등록
        collectionView.delegate = self
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.configureUI()
        self.setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        [
         self.dailyIncome,
         self.dailyExpense,
         self.listCollectionView
        ].forEach { self.addSubview($0) }
    }
    
    private func setupLayout() {
        self.dailyIncome.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(20)
            $0.trailing.equalTo(dailyExpense.snp.leading).offset(-20)
            $0.height.equalTo(50)
        }

        self.dailyExpense.snp.makeConstraints {
            $0.centerY.equalTo(dailyIncome.snp.centerY)
            $0.trailing.equalTo(self.snp.trailing).offset(-20)
        }

        self.listCollectionView.snp.makeConstraints {
            $0.top.equalTo(dailyIncome.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(self).inset(20)
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension DailyTransactionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 20 // 좌우 여백을 고려한 너비
        return CGSize(width: width, height: 70) // 원하는 셀 높이
    }
}
