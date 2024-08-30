//
//  FinacialLedgerVC.swift
//  Smssme
//
//  Created by KimRin on 8/28/24.
//

import UIKit
import SnapKit

final class MoneyDiaryVC: UIViewController {
    
    private lazy var scrollView = UIScrollView()
    let moneyDiaryView: MoneyDiaryView
    private let calendar = Calendar.current
    private let dateFormatter = DateFormatter()
    private var calendarDate = Date()
    private var calendarItems = [CalendarItem]()
    
    init(moneyDiaryView: MoneyDiaryView) {
        self.moneyDiaryView = moneyDiaryView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupUI()
        self.setupLayout()
        self.setupActions()
    }

    private func updateView(selectedIndex: Int) {
        moneyDiaryView.calendarView.isHidden = selectedIndex != 0
    }
    
    
    
    private func setupUI() {
        self.view.addSubview(self.scrollView)
        [
            self.moneyDiaryView
        ].forEach { self.scrollView.addSubview($0) }

        self.configureCalendar()
        self.configureWeekLabel()
        moneyDiaryView.calendarView.calendarCollectionView.dataSource = self
        moneyDiaryView.calendarView.calendarCollectionView.delegate = self
    }
    
    private func setupLayout() {
        self.scrollView.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        self.moneyDiaryView.snp.makeConstraints {
            $0.edges.equalTo(self.scrollView.safeAreaLayoutGuide)
        }
    }
    private func configureWeekLabel() {
        self.moneyDiaryView.calendarView.weekStackView.distribution = .fillEqually
        let dayOfTheWeek = ["일", "월", "화", "수", "목", "금", "토"]
        for i in 0...6 {
            let label = UILabel()
            label.text = dayOfTheWeek[i]
            switch label.text {
            case "토": label.textColor = .blue
            case "일": label.textColor = .red
            default: label.textColor = .black
            }
            label.backgroundColor = .systemGray.withAlphaComponent(0.2)
            label.font = .systemFont(ofSize: 13, weight: .bold)
            label.layer.borderColor = UIColor.systemGray.cgColor
            label.layer.borderWidth = 1.0
            label.textAlignment = .center
            self.moneyDiaryView.calendarView.weekStackView.addArrangedSubview(label)
        }
    }
    
    private func setupActions() {
        moneyDiaryView.previousButton.addTarget(self, action: #selector(self.didPreviousButtonTouched), for: .touchUpInside)
        moneyDiaryView.nextButton.addTarget(self, action: #selector(self.didNextButtonTouched), for: .touchUpInside)
        moneyDiaryView.segmentController.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        moneyDiaryView.todayButton.addTarget(self, action: #selector(self.didTodayButtonTouched), for: .touchUpInside)
    }

    
}

extension MoneyDiaryVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.showHalfModel()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        42//셀개수 고정 (6주 * 7일)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.reuseIdentifier, for: indexPath) as? CalendarCollectionViewCell else { return UICollectionViewCell() }
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 0.7
        cell.updateDate(item: self.calendarItems[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalWidth = collectionView.frame.width
        let numberOfItemsPerRow: CGFloat = 7  // 가로로 7개 배치
        let itemWidth = totalWidth / numberOfItemsPerRow
        let itemHeight = itemWidth * 1.3
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0 //여백없음
    }
}

extension MoneyDiaryVC {
    
    private func configureCalendar() {
        self.dateFormatter.dateFormat = "yyyy년 MM월"
        self.today()
    }
    
    private func startDayOfTheWeek() -> Int {
        return self.calendar.component(.weekday, from: self.calendarDate) - 1
    }
    
    private func endDate() -> Int {
        return self.calendar.range(of: .day, in: .month, for: self.calendarDate)?.count ?? Int()
    }
    
    private func updateCalendar() {
        self.updateTitle()
        self.updateDays()
    }
    
    private func updateTitle() {
        let date = self.dateFormatter.string(from: self.calendarDate)
        self.moneyDiaryView.titleLabel.text = date
    }
    
    private func updateDays() {
        self.calendarItems.removeAll()
        
        let thisMonth = calendar.component(.month, from: self.calendarDate)
        var lastMonth: Int { thisMonth - 1 }
        var nextMonth: Int { 
            if thisMonth == 12 { return 1 }
            else { return thisMonth + 1 }
                                     }
        
        let startDayOfTheWeek = self.startDayOfTheWeek()
        let totalDaysInMonth = self.endDate()
        
        let totalCells = 42
        let emptyCells = startDayOfTheWeek
        print(lastMonth)
        print(emptyCells)
        let remainingCells = totalCells - emptyCells - totalDaysInMonth
        var nextMonthCount = 1
        
        var dates = [String]()
        
        
        for _ in 0..<emptyCells {
            dates.append("")
        }
        
        
        for day in 1...totalDaysInMonth {
            switch day {
            case 1: dates.append("\(thisMonth).\(day)")
            default : dates.append("\(day)")
            }
        }
        for _ in 0..<remainingCells {
            switch nextMonthCount {
            case 1: dates.append("\(nextMonth).\(nextMonthCount)")
            default : dates.append("\(nextMonthCount)")
            }
            nextMonthCount += 1
        }
        
        
        for (index, date) in dates.enumerated() {
            let isSat = (index + 1) % 7 == 0
            let isHol = index == 0 || index % 7 == 0
            self.calendarItems.append(CalendarItem(date: date, isSat: isSat, isHol: isHol))
        }
        
        self.moneyDiaryView.calendarView.calendarCollectionView.reloadData()
    }
    private func moveToSomeDate(_ when: Int ){
        self.calendarDate = self.calendar.date(byAdding: DateComponents(month: when), to: self.calendarDate) ?? Date()
        self.updateCalendar()
    }
    
    private func today() {
        let components = self.calendar.dateComponents([.year, .month], from: Date())
        self.calendarDate = self.calendar.date(from: components) ?? Date()
        self.updateCalendar()
    }
    //    func showHalfModel() {
    //        let modalVc = TransactionListViewController()
    //        modalVc.modalPresentationStyle = .pageSheet
    //
    //        if let sheet = modalVc.sheetPresentationController {
    //            sheet.detents = [.medium()]
    //            sheet.prefersGrabberVisible = true
    //        }
    //
    //
    //        self.present(modalVc, animated: true, completion: nil)
    //    }
        
    
}

extension MoneyDiaryVC {
    func showHalfModel() {
        let modalVc = DailyTransactionVC(transactionView: DailyTransactionView())
        modalVc.modalPresentationStyle = .pageSheet
        
        if let sheet = modalVc.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        
        self.present(modalVc, animated: true, completion: nil)
    }
//objc method
    @objc private func didPreviousButtonTouched(_ sender: UIButton) {
        self.moveToSomeDate(-1)
    }
    
    @objc private func didNextButtonTouched(_ sender: UIButton) {
        self.moveToSomeDate(+1)
    }
    @objc private func didTodayButtonTouched(_ sender: UIButton) {
        self.today()
    }
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        updateView(selectedIndex: sender.selectedSegmentIndex)
    }
    
}


protocol CellReusable {
    static var reuseIdentifier: String { get }
}
extension CellReusable {
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
}



