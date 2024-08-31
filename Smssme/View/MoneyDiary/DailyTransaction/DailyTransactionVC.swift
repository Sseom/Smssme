//
//  DailyTransactionVC.swift
//  Smssme
//
//  Created by KimRin on 8/29/24.
//

import UIKit

class DailyTransactionVC: UIViewController {
    let transactionView = DailyTransactionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureBasicSetting()
        self.configureUI()
    }

    func configureBasicSetting() {
        transactionView.listCollectionView.dataSource = self
        transactionView.listCollectionView.delegate = self
        transactionView.listCollectionView.register(DailyTransactionCell.self, forCellWithReuseIdentifier: DailyTransactionCell.reuseIdentifier)
    }

    private func configureUI() {
        self.view.addSubview(transactionView)
        transactionView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
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

