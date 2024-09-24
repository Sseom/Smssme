//
//  DailyTransactionVC.swift
//  Smssme
//
//  Created by KimRin on 8/29/24.
//0924 rin

import UIKit
import SnapKit

final class DailyTransactionVC: UIViewController {

    let transactionView: DailyTransactionView
    var transactionList: [Diary] = []
    var today = Date()

    
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
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        transactionView.listCollectionView.reloadData()
        reloadTotalAmount()
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

    func setDate(day: Date){
        today = day
        let dateString = DateFormatter.yearMonthDay.string(from: day)
        self.navigationItem.title = dateString
    }
    
    private func reloadTotalAmount() {
        
        if let todayLists = DiaryCoreDataManager.shared.fetchDiaries(on: today) {
            transactionList = todayLists
            var incomeAmount = 0
            var expesneAmount = 0
            
            for item in transactionList {
                if item.statement { incomeAmount += Int(item.amount) }
                else { expesneAmount += Int(item.amount) }
            }
            
            let imcomeString = KoreanCurrencyFormatter.shared.string(from: incomeAmount)
            let expenseString = KoreanCurrencyFormatter.shared.string(from: expesneAmount)

            self.transactionView.dailyIncome.text = "수입: \(imcomeString) 원"
            self.transactionView.dailyExpense.text = "지출: \(expenseString) 원"
            
        }
    }
    
}

extension DailyTransactionVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = MoneyDiaryEditVC(transactionItem2: transactionList[indexPath.row])
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return transactionList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DailyTransactionCell.reuseIdentifier,
            for: indexPath) as? DailyTransactionCell
                
        else { return UICollectionViewCell() }
        
        cell.updateData(transaction: transactionList[indexPath.row])
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

