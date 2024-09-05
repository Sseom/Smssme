//
//  DailyTransactionVC.swift
//  Smssme
//
//  Created by KimRin on 8/29/24.
//

import UIKit

class DailyTransactionVC: UIViewController {

    let transactionView: DailyTransactionView
    
    var dailyIncome = 0
    var dailyExpense = 0
    var transactionList: [Diary] = []
    var today = Date()
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
        self.transactionView.listCollectionView.reloadData()
    }
    
    private func setupUI() {
        configureCell()
        transactionView.listCollectionView.dataSource = self
        transactionView.listCollectionView.delegate = self
        transactionView.listCollectionView.register(DailyTransactionCell.self, forCellWithReuseIdentifier: DailyTransactionCell.reuseIdentifier)
        self.view.addSubview(transactionView)
        
        transactionView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        
    }
    
    func configureCell() {
        if let todayLists = DiaryCoreDataManager.shared.fetchDiaries(on: today)
        {
            transactionList = todayLists
                    
        }
    }
    
    
    private func calculateTodayTransaction(items: [Diary]) {
        
        var incomeList = 0
        var expesneList = 0
        
        for item in items {
            if item.statement { incomeList += Int(item.amount) }
            else { expesneList += Int(item.amount) }
        }
        
        self.dailyIncome = incomeList
        self.dailyExpense = expesneList
    }
    
    func setDate(day: Date) {

        today = day

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let dayString = dateFormatter.string(from: day)
        self.transactionView.dateLabel.text = dayString
        
    }
    
    func counter (amount: Int) -> String {
        let temp = String(amount)
        
        if temp.count > 10 {
            let temp2 = Double(amount) * 0.001
            //1500원은 0.15만->
            //1000000 원 100만?
            return String(temp2)
            
        }
        else { return temp }
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
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DailyTransactionCell.reuseIdentifier, for: indexPath) as? DailyTransactionCell
        else { return UICollectionViewCell() }
        // 셀 설정
        cell.updateData(transaction: transactionList[indexPath.row])
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

