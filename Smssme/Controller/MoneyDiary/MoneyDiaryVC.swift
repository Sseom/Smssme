//
//  FinacialLedgerVC.swift
//  Smssme
//
//  Created by KimRin on 8/28/24.
// 09/15 진행중

import DGCharts
import SnapKit
import UIKit


final class MoneyDiaryVC: UIViewController {

    private lazy var scrollView = UIScrollView()
    private let moneyDiaryView: MoneyDiaryView
    private let datePicker = DatePickerView()
    
    private var diaries: [Diary] = []
    private var dataEntries: [PieChartDataEntry] = []

    private var calendar = Calendar.current
    private var calendarDate = Date()
    private var calendarItems = [CalendarItem]()
    private var animation: UIViewPropertyAnimator?
    
    private var isActive: Bool = false {
        didSet {
            showActionButtons()
        }
    }
    
    
    init(moneyDiaryView: MoneyDiaryView) {
        self.moneyDiaryView = moneyDiaryView
        super.init(nibName: nil, bundle: nil)
        self.scrollView.backgroundColor = .white
        self.view.backgroundColor = .white
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
        datePicker.confirmButton.addTarget(self, action: #selector(didChoiceYearMonth), for: .touchUpInside)
        moneyDiaryView.moveBudgetButton.addTarget(self, action: #selector(didTapBudgetButton), for: .touchUpInside)
        moneyDiaryView.floatingButton.addTarget(self, action: #selector(didTapFloatingButton), for: .touchUpInside)
        moneyDiaryView.quickMessageButton.addTarget(self, action: #selector(didTapAutoSaving), for: .touchUpInside)
    }
    
}

//collectionView 구성
extension MoneyDiaryVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private func updateCalendar() {
        let date = DateFormatter.yearMonthKR.string(from: self.calendarDate)
        self.moneyDiaryView.dateButton.setTitle(date, for: .normal)
        
        self.calendarItems.removeAll()
        let temp = DateManager.shared.configureDays(currentMonth: calendarDate)
        let thisMonth = calendar.component(.month, from: calendarDate)
        
        calendarItems = temp.map { i in
            CalendarItem(date: i, isThisMonth: calendar.component(.month, from: i) == thisMonth)
        }
        
        self.moneyDiaryView.calendarView.calendarCollectionView.reloadData()
        
    }
    
    
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
        
        


        
        configureBackground(monthBudget: 1500000)
        
        
        cell.updateDate(item: self.calendarItems[indexPath.item])
        
        return cell
    }
    
    
    func configureBackground(monthBudget: Int?) {
        //monthBudget이 있을수도 없을수도 있음 없는경우 실행 안함
        guard let monthBudgetValue = monthBudget else { return }
        //일일 예산은 월예산나누기/ 당월일수
        let dayBudget = monthBudgetValue / DateManager.shared.getWeekdayNum(month: self.calendarDate)
        //섹션번호: 섹션예산으로 잡을 예정
        var weekSectionWithValue = [0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0]
        //섹션의 값을 넣어주기 위한 변수 설정
        var weekCount = 0
        var weekValue = 0
        
        for (index, calendarItem) in calendarItems.enumerated(){
            if calendarItem.isThisMonth { //이번달일때
                
                calendarItems[index].weekSection = weekCount

                
            }
            
            

            
            calWeek()
            let weeklyBudgets = temp(calendarItems: self.calendarItems) // 이러면 각주당 일수나옴
            //[3,7,7,7,7]
            // 7개씩 차례로 들어감 총 42개가
            //0...6  7...13  14...20  21...27  28...34 35...41
            //calendar(firstIndex.offset + 7 - weeklyBudget[0]).date
            var week1 = [Date]()
            var week2 = [Date]()
            var week3 = [Date]()
            var week4 = [Date]()
            var week5 = [Date]()
            var week6 = [Date]()
            
            var weeklyExpense = [0, 0, 0, 0, 0, 0]
            
            for (index, item) in calendarItems.enumerated() {
                if item.isThisMonth {
                    switch item.weekSection {
                    case 0:
                        week1.append(item.date)
                    case 1:
                        week2.append(item.date)
                    case 2:
                        week3.append(item.date)
                    case 3:
                        week4.append(item.date)
                    case 4:
                        week5.append(item.date)
                    case 5:
                        week6.append(item.date)
                    default: print("fail 2")
                    }
                }
                
            }
            
            
            
            
            weeklyExpense[0] = getAmount(dates: week1)
            weeklyExpense[1] = getAmount(dates: week2)
            weeklyExpense[2] = getAmount(dates: week3)
            weeklyExpense[3] = getAmount(dates: week4)
            weeklyExpense[4] = getAmount(dates: week5)
            if !week6.isEmpty {
                weeklyExpense[5] = getAmount(dates: week6)
            }
            let colorValue = makeTrafficLightLogic(
                weeklyTransaction: weeklyExpense,
                DayInWeek: weeklyBudgets,
                MonthBudget: 1500000
            )
            
            
        
            

            for i in 0 ..< 42 {
                if calendarItems[i].isThisMonth {
                    switch self.calendarItems[i].weekSection {
                    case 0:
                        calendarItems[i].backgroundColor = colorValue[0]
                    case 1:
                        calendarItems[i].backgroundColor = colorValue[1]
                    case 2:
                        calendarItems[i].backgroundColor = colorValue[2]
                    case 3:
                        calendarItems[i].backgroundColor = colorValue[3]
                    case 4:
                        calendarItems[i].backgroundColor = colorValue[4]
                    case 5:
                        calendarItems[i].backgroundColor = colorValue[5]
                    default:
                        print(#function)
                    }
                }
                
            }



        }
        
        

        
        
    }

    
    func getAmount (dates: [Date]) -> Int {
        var date = dates
        date = [date.removeFirst(),date.removeLast()]
        var weekAmount = 0
        if let weekDiary = DiaryCoreDataManager.shared.fetchDiaries(from: date[0], to: date[1])
        {
            for i in weekDiary {
                if !i.statement {
                    weekAmount += Int(i.amount)
                }
                
            }
        }
        
        
        return weekAmount
    }
    
    
    
    func calWeek() {
        var weekCount = 0

        
        for (index,item) in self.calendarItems.enumerated() {
            
            if item.isThisMonth {
                calendarItems[index].weekSection = weekCount
                if DateManager.shared.getWeekdayNum(month: calendarItems[index].date) == 7 {
                    weekCount += 1
                }
            }

                
        }
        weekCount = 0
    }
    
    func temp(calendarItems: [CalendarItem]) -> [Int]{
        
        var sections: [Int] = [0, 0, 0, 0, 0, 0]
        for item in calendarItems { //index.range = 0...28~30
            
            if item.isThisMonth {
                
                switch item.weekSection {
                case 0: 
                    sections[0] += 1
                    
                case 1: sections[1] += 1
                case 2: sections[2] += 1
                case 3: sections[3] += 1
                case 4: sections[4] += 1
                case 5: sections[5] += 1
                default: print("fail")
                }
            }

        }
        

        
        return sections
        
//        let monthBudgetValue = 1500000
//        let dayBudget = monthBudgetValue / DateManager.shared.getWeekdayNum(month: self.calendarDate)
//        var daysInWeek =
//        var weekValue: Int {
//            dayBudget * daysInWeek
        
        
    }
    

    
    
    func makeTrafficLightLogic(weeklyTransaction: [Int], DayInWeek: [Int], MonthBudget:Int) -> [UIColor]{
        //각 컬러값
        let redLight = UIColor(hex: "#FF7052")
        let greenLight = UIColor(hex: "#2DC76D")
        let yellowLight = UIColor(hex: "#FFC800")
        var bgColors: [UIColor] = []
        let dayBudget = MonthBudget / DateManager.shared.endOfDateNumber(month: self.calendarDate)
        var weeklyBudget = DayInWeek.map{ $0 * dayBudget }
        for i in 0 ..< 6 {
            
            switch weeklyTransaction[i] {
                
            case 0...weeklyBudget[i] :
                bgColors.append(greenLight)
                
            case  weeklyBudget[i] ..< Int(Double(weeklyBudget[i]) * 1.15) :
                bgColors.append(yellowLight)
            
                
            default:
                bgColors.append(redLight)
                
                
            }
            
        }
        
        
        return bgColors
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

//ChartView 구성
extension MoneyDiaryVC : ChartViewDelegate {
    
    func configureAmountOfMonth() {
        let firstDay = DateManager.shared.getFirstDayInMonth(date: self.calendarDate)
        let lastDay = DateManager.shared.getlastDayInMonth(date: self.calendarDate)
        guard let diaries = DiaryCoreDataManager.shared.fetchDiaries(from: firstDay, to: lastDay)
        else { return }
        self.diaries = diaries
    }
    
    private func setChart(centerTotalValue: Int64) {
        //        moneyDiaryView.chartView.delegate = self
        
        if !dataEntries.isEmpty {
            let dataSet = PieChartDataSet(entries: dataEntries, label: "")
            dataSet.valueFormatter = PercentageValueFormatter()
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
            moneyDiaryView.chartView.centerText = "합계\n\(centerTotalValue) 원"
        } else {
            moneyDiaryView.chartView.data = nil
            moneyDiaryView.chartView.notifyDataSetChanged()
        }
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
            setChart(centerTotalValue: totalAmount)
        } else {
            return
        }
    }
}

//ButtonEvent 구성
extension MoneyDiaryVC {
    @objc private func didTapFloatingButton() {
        isActive.toggle()
    }
    
    private func showActionButtons() {
        moneyDiaryView.popButtons(isActive: isActive)

    }
    
    @objc private func didTapBudgetButton() {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: calendarDate)
        let viewController = MoneyDiaryBudgetEditVC(currentYear: components.year ?? 0, currentMonth: components.month ?? 0)
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
    
    @objc func didTapAutoSaving() {
        let viewController = AutomaticTransactionVC()
        isActive.toggle()
        self.navigationController?.pushViewController(viewController, animated: false)
        
    }
    
    // 연필 아이콘 동작
    private func pencilButtonAction() {
        
        let action = UIAction { [weak self] _ in
            self?.navigationController?.pushViewController(MoneyDiaryCreationVC(diaryManager: DiaryCoreDataManager(), transactionItem2: Diary()), animated: true)
        }
        
        moneyDiaryView.addActionToPencilButton(action)
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
    
    private func moveToSomeDate(_ when: Date? ){
        guard let safeDate = when
        else { return }
        let components = self.calendar.dateComponents([.year, .month], from: safeDate)
        self.calendarDate = self.calendar.date(from: components) ?? Date()
        self.updateCalendar()
        self.setChartData()
    }
    
}

//datePickerView 구성
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
    
    @objc func didChoiceYearMonth() {
        let selectedYearValue = datePicker.years[datePicker.pickerView.selectedRow(inComponent: 0)]
        let selectedMonthValue = datePicker.months[datePicker.pickerView.selectedRow(inComponent: 1)]
        var selectedDate = ""
        if selectedMonthValue >= 10 {
            selectedDate = "\(selectedYearValue)-\(selectedMonthValue)"}
        else {selectedDate = "\(selectedYearValue)-0\(selectedMonthValue)"}
        
        let temp1 = DateFormatter.yearMonth.date(from: selectedDate)
        
        self.dismiss(animated: true)
        
        moveToSomeDate(temp1)
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




