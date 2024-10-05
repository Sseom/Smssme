// DailyTransactionVC.swift
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class DailyTransactionVC: UIViewController {
    let transactionView: DailyTransactionView
    var viewModel: DailyTransactionViewModel
    private let disposeBag = DisposeBag()
    
    init(transactionView: DailyTransactionView, viewModel: DailyTransactionViewModel) {
        self.transactionView = transactionView
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        view.backgroundColor = .white
    }
    override func viewWillAppear(_ animated: Bool) {
        transactionView.listCollectionView.reloadData()
    }
    
    private func setupUI() {
        transactionView.listCollectionView.dataSource = self
        transactionView.listCollectionView.delegate = self
        transactionView.listCollectionView.register(DailyTransactionCell.self, forCellWithReuseIdentifier: DailyTransactionCell.reuseIdentifier)
        
        self.view.addSubview(transactionView)
        transactionView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    func setDate(day: Date) {
        viewModel.fetchTransactions(for: day)
        let dateString = DateFormatter.yearMonthDay.string(from: day)
        self.navigationItem.title = dateString
    }
    
    private func bindViewModel() {
        viewModel.dailyIncome
            .drive(transactionView.dailyIncome.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.dailyExpense
            .drive(transactionView.dailyExpense.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.transactions
            .drive(onNext: { [weak self] _ in
                self?.transactionView.listCollectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

// Extension for UICollectionViewDataSource and UICollectionViewDelegateFlowLayout
extension DailyTransactionVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = MoneyDiaryEditVC(transactionItem2: viewModel.transaction(at: indexPath.row))
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.transactionCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DailyTransactionCell.reuseIdentifier,
            for: indexPath) as? DailyTransactionCell else {
            return UICollectionViewCell()
        }
        
        let transaction = viewModel.transaction(at: indexPath.row)
        cell.updateData(transaction: transaction)
        cell.layer.cornerRadius = 20
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
        return cell
    }
}

extension DailyTransactionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        return CGSize(width: width, height: 70)
    }
}
