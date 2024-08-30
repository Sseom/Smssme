//
//  DailyTransactionVC.swift
//  Smssme
//
//  Created by KimRin on 8/29/24.
//

import UIKit

class DailyTransactionVC: UIViewController {
    let transactionView: DailyTransactionView
    var dailyTransactionList: [TransactionItem] = []
    var dailyIncome = 0
    var dailyExpense = 0
    
    init(transactionView: DailyTransactionView) {
        self.transactionView = transactionView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
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
    
    private func calculateTodayTransaction(TransactionList: [TransactionItem]) {
        var incomeList = 0
        var expesneList = 0
        
        for Transaction in TransactionList {
            if Transaction.isIncom { incomeList += Transaction.Amount}
            else { expesneList += Transaction.Amount}
        }
        
        self.dailyIncome = incomeList
        self.dailyExpense = expesneList
    }
    
    
    
    
}

extension DailyTransactionVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DailyTransactionCell.reuseIdentifier, for: indexPath) as? DailyTransactionCell
        else { return UICollectionViewCell() }
        // 셀 설정
        cell.layer.cornerRadius = 20
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
        return cell
    }
}

extension DailyTransactionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width // 좌우 마진을 뺀 너비
        return CGSize(width: width, height: 70) // 셀의 높이를 80으로 설정
    }
}

