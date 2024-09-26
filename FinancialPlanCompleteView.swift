import SnapKit
import UIKit

final class FinancialPlanCompleteView: UIView {
    private let title = LabelFactory.titleLabel()
        .setText("짝짝! 완료한 목표")
        .build()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.register(FinancialPlanCompleteCell.self, forCellWithReuseIdentifier: FinancialPlanCompleteCell.ID)
        collectionView.backgroundColor = UIColor(hex: "#e9f3fd")
        collectionView.layer.cornerRadius = 30
        collectionView.clipsToBounds = true
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
        [
            title,
            collectionView
        ].forEach { addSubview($0) }
        
        title.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(10)
            $0.leading.equalToSuperview().offset(20)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
    
    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
        
        let totalSpacing = layout.minimumInteritemSpacing + layout.sectionInset.left + layout.sectionInset.right
        let itemWidth = (UIScreen.main.bounds.width - 40 - totalSpacing) / 2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.3)
        return layout
    }
}
