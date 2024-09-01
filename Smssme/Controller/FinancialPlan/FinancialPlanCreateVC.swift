//
//  FinancialPlanCreateVC.swift
//  Smssme
//
//  Created by 임혜정 on 8/27/24.
//

import UIKit

class FinancialPlanCreateVC: UIViewController {
    private var financialPlanCreateView = FinancialPlanCreateView(textFieldArea: CreateTextView())
    private let textFieldArea = CreateTextView()
    
    // 임시. 아마도 캘린더 구현 작업물에 한국날짜 변환 부분이 있을 것 같은데..리인님 병합 후에 있다면 그것으로 쓰고 없다면 분리해줄 예정
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
    
    init(textFieldArea: CreateTextView) {
        self.financialPlanCreateView = FinancialPlanCreateView(textFieldArea: textFieldArea)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupActions()
    }
    
    override func loadView() {
        view = financialPlanCreateView
    }
    
    private func setupActions() {
        financialPlanCreateView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        
        let datePicker = textFieldArea.datePicker
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateString = dateFormatter.string(from: sender.date)
        if textFieldArea.startDateField.isFirstResponder {
            textFieldArea.startDateField.text = dateString
        } else if textFieldArea.endDateField.isFirstResponder {
            textFieldArea.endDateField.text = dateString
        }
    }
}

extension FinancialPlanCreateVC {
 
    @objc func dismissKeyboard() {
        resignFirstResponder()
    }
    
    @objc func confirmButtonTapped() {
        print("탭뜨")
        let financialPlanConfirmVC = FinancialPlanConfirmVC()
        navigationController?.pushViewController(financialPlanConfirmVC, animated: true)
    }
}

