//
//  FinancialPlanCreateVC.swift
//  Smssme
//
//  Created by 임혜정 on 8/27/24.
//

import UIKit

class FinancialPlanCreateVC: UIViewController {
    
    private let financialPlanCreateView: FinancialPlanCreateView
    
    init(financialPlanCreateView: FinancialPlanCreateView) {
        self.financialPlanCreateView = financialPlanCreateView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 임시. 아마도 캘린더 구현 작업물에 한국날짜 변환 부분이 있을 것 같은데..리인님 병합 후에 있다면 그것으로 쓰고 없다면 분리해줄 예정
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupDatePicker()
        financialPlanCreateView.confirmButton.addTarget(self, action: #selector(confirmButtomTapped), for: .touchUpInside)
    }
    
    override func loadView() {
        view = financialPlanCreateView
    }
    
    private func setupDatePicker() {
        financialPlanCreateView.startDateField.inputView = financialPlanCreateView.datePicker
        financialPlanCreateView.endDateField.inputView = financialPlanCreateView.datePicker2
        financialPlanCreateView.datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        financialPlanCreateView.datePicker2.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        updateDateTextField()
    }
    
    private func updateDateTextField() {
        financialPlanCreateView.startDateField.text = dateFormatter.string(from: financialPlanCreateView.datePicker.date)
        financialPlanCreateView.endDateField.text = dateFormatter.string(from: financialPlanCreateView.datePicker2.date)
    }
}

extension FinancialPlanCreateVC {
    @objc private func dateChanged() {
        updateDateTextField()
    }
    
    @objc func dismissKeyboard() {
        resignFirstResponder()
    }
    
    @objc func confirmButtomTapped() {
        let financialPlanConfirmVC = FinancialPlanConfirmVC(financialPlanConfirmView: FinancialPlanConfirmView())
        navigationController?.pushViewController(financialPlanConfirmVC, animated: true)
    }
}
