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
    var calendar = Calendar.current
    private let dateFormatter = DateFormatter()
    private var calendarDate = Date()
    private var calendarItems = [CalendarItem]()
    
    let datePicker = DatePickerView()
    
    
    init(moneyDiaryView: MoneyDiaryView) {
        self.moneyDiaryView = moneyDiaryView
        super.init(nibName: nil, bundle: nil)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        let date = self.calendar.date(byAdding: DateComponents(month: -1), to: calendarDate)
        
        DateManager.shared.configureDays(currentMonth: date!)
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupUI()
        self.setupLayout()
        self.setupActions()
        

        
    }

    private func updateView(selectedIndex: Int) {
        if selectedIndex != 0 {
            moneyDiaryView.calendarView.isHidden = true
            moneyDiaryView.chartView.isHidden = false
        } else {
            moneyDiaryView.calendarView.isHidden = false
            moneyDiaryView.chartView.isHidden = true
        }
    }

    private func setupUI() {
        self.navigationItem.title = "모두모두 행복하세요~ 가계부~~"
        self.view.addSubview(self.scrollView)
        [
            self.moneyDiaryView
        ].forEach { self.scrollView.addSubview($0) }

        moveToSomeDate(Date())
        
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

    
    private func setupActions() {
        
        moneyDiaryView.previousButton.addTarget(self, action: #selector(self.didPreviousButtonTouched), for: .touchUpInside)
        moneyDiaryView.nextButton.addTarget(self, action: #selector(self.didNextButtonTouched), for: .touchUpInside)
        moneyDiaryView.segmentController.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        moneyDiaryView.todayButton.addTarget(self, action: #selector(self.didTodayButtonTouched), for: .touchUpInside)
        moneyDiaryView.moveDateButton.addTarget(self, action: #selector(didTapMoveButton), for: .touchUpInside)
        datePicker.confirmButton.addTarget(self, action: #selector(didTapMove), for: .touchUpInside)
    }

    @objc func didTapMove() {
        let selectedYearValue = datePicker.years[datePicker.pickerView.selectedRow(inComponent: 0)]
        let selectedMonthValue = datePicker.months[datePicker.pickerView.selectedRow(inComponent: 1)]
        var selectedDate = ""
        if selectedMonthValue >= 10 {
            selectedDate = "\(selectedYearValue)-\(selectedMonthValue)"}
        else {selectedDate = "\(selectedYearValue)-0\(selectedMonthValue)"}
        let dateformatter1 = DateFormatter()
        dateformatter1.dateFormat = "yyyy-MM"
        
        let temp1 = dateformatter1.date(from: selectedDate)
        
        self.dismiss(animated: true)
        
        moveToSomeDate(temp1)
    }

    
}

extension MoneyDiaryVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        

            let viewController = DailyTransactionVC(transactionView: DailyTransactionView())

        viewController.setDate(day: self.calendarItems[indexPath.row].date)
        self.navigationController?.pushViewController(viewController, animated: true)
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
    

        
    private func updateCalendar() {
        self.updateTitle()
        self.updateDays()
    }
    
    private func updateTitle() {
        self.dateFormatter.dateFormat = "yyyy년 MM월"
        let date = self.dateFormatter.string(from: self.calendarDate)
        self.moneyDiaryView.currentDateLabel.text = date
    }
    
    private func updateDays() {
        self.calendarItems.removeAll()
        
        let currentMonth = DateManager.shared.configureDays(currentMonth: calendarDate)
        
        for i in 0 ..< 42 {
            calendarItems.append(CalendarItem(date: DateManager.shared.configureDays(currentMonth: calendarDate)[i]))
            
            
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
        
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        //20241201->Int : Id 처럼
//        dateFormatter.dateFormat = "yyyy-MM-dd"
        
//        dateFormatter.
        components.hour = 0
        components.minute = 0
        components.second = 0
        let dateWithoutTime = calendar.date(from: components)
        return dateWithoutTime
    }

}

extension MoneyDiaryVC {

//objc method
    
    @objc private func didPreviousButtonTouched(_ sender: UIButton) {
        self.moveToSomeDate(self.calendar.date(byAdding: DateComponents(month: -1), to: self.calendarDate))
    }
    
    @objc private func didNextButtonTouched(_ sender: UIButton) {
        
        self.moveToSomeDate(calendar.date(byAdding: DateComponents(month: 1), to: self.calendarDate))
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


protocol CellReusable {
    static var reuseIdentifier: String { get }
}
extension CellReusable {
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
}




