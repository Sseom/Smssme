import UIKit
import RxSwift
import RxCocoa
import SnapKit

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
        
        transactionView.listCollectionView.rx.itemSelected
            .withLatestFrom(output.transactionList) { IndexPath, transaction in
                return transaction[IndexPath.row]
            }
            .subscribe(onNext: { [weak self] transaction in
                let vc = MoneyDiaryEditVC(transactionItem2: transaction)
                self?.navigationController?.pushViewController(vc, animated: true)
                
                
            }).disposed(by: disposeBag)
        
        
    }

}





