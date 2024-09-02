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
    
    let datePicker = DatePickerView()
    
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
        datePicker.pickerView.delegate = self
        datePicker.pickerView.dataSource = self
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
        moneyDiaryView.budgetPlanButton.addTarget(self, action: #selector(didTapMoveButton), for: .touchUpInside)
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
        self.moveToSomeDate(Date())
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
        let dateForm = DateFormatter()
        let thisMonth = calendar.component(.month, from: self.calendarDate)
        var lastMonth: Int { thisMonth - 1 }
        var nextMonth: Int { 
            if thisMonth == 12 { return 1 }
            else { return thisMonth + 1 }
                                     }
        var lastMonthOfEndDate = calendarDate.addingTimeInterval(-86400)
        print(lastMonthOfEndDate)
        dateForm.dateFormat = "dd"
        
        let temp2 = dateForm.string(from: lastMonthOfEndDate)
        print(temp2)
        let startDayOfTheWeek = self.startDayOfTheWeek()
        let totalDaysInMonth = self.endDate()
        
        let totalCells = 42
        let emptyCells = startDayOfTheWeek
        
        
        let remainingCells = totalCells - emptyCells - totalDaysInMonth
        
        var nextMonthCount = 1
        
        var dates = [String]()
        var lastMonthDays: [Date] = []
        for i in 0..<emptyCells {
            let temp = lastMonthOfEndDate.addingTimeInterval(-86400 * Double(i) )
            print(dateForm.string(from: temp))
            lastMonthDays.append(temp)
        }
        print(lastMonthDays)
        for i in 0..<emptyCells {
            
//            lastMonthDays.append(lastMonthOfEndDate)
            
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
    private func moveToSomeDate(_ when: Date? ){
        guard let safeDate = when
        else { return }
        let components = self.calendar.dateComponents([.year, .month], from: safeDate)
        self.calendarDate = self.calendar.date(from: components) ?? Date()
        self.updateCalendar()
    }
    
    

    
    
    private func transformToAble(date: Date) -> Date? {
        let componenets = calendar.dateComponents([.year, .month, .day], from: date)
        let temp = calendar.date(from: componenets)
        return temp
        
    }


        
    
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
        
        self.moveToSomeDate(self.calendar.date(byAdding: DateComponents(month: -1), to: self.calendarDate))
    }
    
    @objc private func didNextButtonTouched(_ sender: UIButton) {
        
        self.moveToSomeDate(calendar.date(byAdding: DateComponents(month: -1), to: self.calendarDate))
    }
    @objc private func didTodayButtonTouched(_ sender: UIButton) {
        self.moveToSomeDate(Date())
    }
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        updateView(selectedIndex: sender.selectedSegmentIndex)
    }
    @objc private func didTapMoveButton(){
        
            let modalVc = UIViewController()
        modalVc.view = datePicker
            modalVc.modalPresentationStyle = .pageSheet
            
        let currentMonth = calendar.component(.month, from: calendarDate)
        let currentYear = calendar.component(.year, from: calendarDate)
        print(currentMonth,currentYear)
        if let temp = datePicker.years.firstIndex(of: currentYear) {
            datePicker.pickerView.selectRow(temp, inComponent: 0, animated: true)
        }
        if let temp2 = datePicker.months.firstIndex(of: currentMonth) {
            datePicker.pickerView.selectRow(temp2, inComponent: 1, animated: true)
        }
            
            
            
            if let sheet = modalVc.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
            }
            
            self.present(modalVc, animated: true, completion: nil)
        }
    
    
}

extension MoneyDiaryVC:  UIPickerViewDelegate,UIPickerViewDataSource {
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? datePicker.years.count : datePicker.months.count
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return component == 0 ? "\(datePicker.years[row])년" : "\(datePicker.months[row])월"
    }
    
}






