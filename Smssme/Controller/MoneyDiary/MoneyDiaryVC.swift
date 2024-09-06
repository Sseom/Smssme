//
//  FinacialLedgerVC.swift
//  Smssme
//
//  Created by KimRin on 8/28/24.
//

import DGCharts
import SnapKit
import UIKit

final class MoneyDiaryVC: UIViewController {
    private var diaries: [Diary] = []
    private var dataEntries: [PieChartDataEntry] = []
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
        
        pencilButtonAction()
    }

   
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureAmountOfMonth()
        
        self.moneyDiaryView.calendarView.calendarCollectionView.reloadData()
    }
    
    func setChartData() {
        if let diaries = DiaryCoreDataManager.shared.fetchDiaries(from: DateManager.shared.getFirstDayInMonth(date: calendarDate), to: DateManager.shared.getlastDayInMonth(date: calendarDate)){
            
            let totalAmount = diaries.filter { !$0.statement }
                .reduce(0) { $0 + $1.amount }
            
            dataEntries = Dictionary(grouping: diaries.filter { !$0.statement }, by: { $0.category ?? "" })
                .mapValues { $0.reduce(0) { $0 + $1.amount } }
                .map {
                    return PieChartDataEntry(value: (Double($1) / Double(totalAmount)) * 100, label: $0)
                }
        } else {
            return
        }
        print(dataEntries)
        setChart()
    }

    private func updateView(selectedIndex: Int) {
        if selectedIndex != 0 {
            moneyDiaryView.calendarView.isHidden = true
            moneyDiaryView.chartView.isHidden = false
            setChartData()
        } else {
            moneyDiaryView.calendarView.isHidden = false
            moneyDiaryView.chartView.isHidden = true
        }
    }

    private func setupUI() {
        self.navigationItem.title = "가계부"
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
        moneyDiaryView.dateButton.addTarget(self, action: #selector(didTapMoveButton), for: .touchUpInside)
        datePicker.confirmButton.addTarget(self, action: #selector(didTapMove), for: .touchUpInside)
        moneyDiaryView.moneyBudgeyButton.addTarget(self, action: #selector(didTapBudgetButton), for: .touchUpInside)
    }
    
    private func setChart() {
//        moneyDiaryView.chartView.delegate = self
        
        if !dataEntries.isEmpty {
            let dataSet = PieChartDataSet(entries: dataEntries, label: "")
            dataSet.colors = dataEntries.map { _ in
                return UIColor(red: CGFloat.random(in: 0.5...1),
                               green: CGFloat.random(in: 0.5...1),
                               blue: CGFloat.random(in: 0.5...1),
                               alpha: 1.0)
            }
            dataSet.valueColors = dataSet.colors.map { _ in
                return .darkGray
            }
            let data = PieChartData(dataSet: dataSet)
            moneyDiaryView.chartView.data = data
        } else {
            moneyDiaryView.chartView.data = nil
            moneyDiaryView.chartView.notifyDataSetChanged()
        }
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
    func configureAmountOfMonth() {
        
        let firstDay = DateManager.shared.getFirstDayInMonth(date: self.calendarDate)
        let lastDay = DateManager.shared.getlastDayInMonth(date: self.calendarDate)
        guard let diaries = DiaryCoreDataManager.shared.fetchDiaries(from: firstDay, to: lastDay)
        else { return }
        self.diaries = diaries

        
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
//        print(cell.currentDate)
//        for calendarItem in calendarItems {
//            calendarItem.date = Date()
//        }
        
        
        
        
        

        

        
        
        
        
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
        
        self.moneyDiaryView.dateButton.setTitle(date, for: .normal)
    }
    
    private func updateDays() {
        self.calendarItems.removeAll()
        
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
        self.setChartData()
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
    @objc private func didTapBudgetButton() {
        let viewController = MoneyDiaryBudgetEditVC()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
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
    
    // 연필 아이콘 동작
    private func pencilButtonAction() {
        let action = UIAction { [weak self] _ in
            self?.navigationController?.pushViewController(MoneyDiaryCreationVC(diaryManager: DiaryCoreDataManager(), transactionItem2: Diary()), animated: true)
        }
        moneyDiaryView.addActionToPencilButton(action)
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

extension MoneyDiaryVC: ChartViewDelegate {
    
}



protocol CellReusable {
    static var reuseIdentifier: String { get }
}
extension CellReusable {
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
}




