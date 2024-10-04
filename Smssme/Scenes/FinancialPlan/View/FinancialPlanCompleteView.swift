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
            $0.bottom.equalToSuperview().offset(-60)
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

// MARK: - 아직 완료한 저축목표가 없을 경우
final class IncompleteView: UIView {
    private let title = LabelFactory.titleLabel()
        .setText("목표를 달성해보세요")
        .build()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "notFound")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let incompleteLabel = LabelFactory.bodyLabel()
        .setText("앗, 아직 완료된 재무목표플랜이 없어요")
        .setColor(.disableGray)
        .build()
    
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
            imageView,
            incompleteLabel
        ].forEach { addSubview($0) }
        
        title.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(10)
            $0.leading.equalToSuperview().offset(20)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(80)
            $0.width.height.equalTo(80)
            $0.centerX.equalToSuperview()
        }
        
        incompleteLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
        }
    }
}
