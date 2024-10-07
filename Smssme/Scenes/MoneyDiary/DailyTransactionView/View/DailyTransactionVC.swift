import UIKit

import SnapKit
import RxSwift

final class DailyTransactionVC: UIViewController {

    let transactionView: DailyTransactionView
    let viewModel: DailyTransactionViewModel
    let disposeBag = DisposeBag()
    
    init(today: Date) {
        self.transactionView = DailyTransactionView()
        self.viewModel = DailyTransactionViewModel(today: today)
        
        
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = DateFormatter.yearMonthDay.string(from: today)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setup()
        bind()
        view.backgroundColor = .white
    }
    

    
    private func setup() {

        view.addSubview(transactionView)
        transactionView.snp.makeConstraints{
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }


    }
    
    private func bind() {
        let input = DailyTransactionViewModel.Input(load: self.rx.viewWillAppear)
        
        let output = viewModel.transform(input)
        
        output.transactionList
            .bind(to: transactionView.listCollectionView.rx.items(cellIdentifier: DailyTransactionCell.reuseIdentifier, cellType: DailyTransactionCell.self)) { row, transaction, cell in
                cell.updateData(transaction: transaction)
                
                cell.layer.cornerRadius = 20
                cell.layer.borderWidth = 1
                cell.layer.borderColor = UIColor.black.cgColor
                
            }
            .disposed(by: disposeBag)
        output.incomeString
            .bind(to: transactionView.dailyIncome.rx.text)
            .disposed(by: disposeBag)
        output.expenseString
            .bind(to: transactionView.dailyExpense.rx.text)
            .disposed(by: disposeBag)
        
        
    }

}
extension DailyTransactionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 20 // 좌우 여백을 고려한 너비
        return CGSize(width: width, height: 70) // 원하는 셀 높이
    }
}




