//
//  FinancialPlanCreateVC.swift
//  Smssme
//
//  Created by 임혜정 on 8/27/24.
//

import CoreData
import UIKit
import SafariServices

protocol FinancialPlanCreationDelegate: AnyObject {
    func didCreateFinancialPlan(_ plan: FinancialPlanDTO)
}

class FinancialPlanCreationVC: UIViewController, UITextFieldDelegate {
    weak var creationDelegate: FinancialPlanCreationDelegate?
    private var creationView = FinancialPlanCreationView(textFieldArea: CreatePlanTextFieldView())
    
    private var planService: FinancialPlanService
    
    private var selectedPlanTitle: String?
    private var selectedPlanType: PlanType?
    
    func configure(with title: String, planType: PlanType) {
        self.selectedPlanTitle = title
        self.selectedPlanType = planType
    }
    
    init(planService: FinancialPlanService) {
        self.planService = planService
        super.init(nibName: nil, bundle: nil)
        setupInitialDate()
        setupDatePickerTarget()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupActions()
        setupUI()
        setupTextFields()
    }
    
    override func loadView() {
        view = creationView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        creationView.showTooltip()
    }
    
    private func setupUI() {
        creationView.titleTextField.text = selectedPlanTitle
    }
    
    private func setupTextFields() {
        creationView.textFieldArea.targetAmountField.delegate = self
        creationView.textFieldArea.currentSavedField.delegate = self
        creationView.titleTextField.delegate = self
        creationView.titleTextField.returnKeyType = .done
    }
}

// MARK: - 화면전환관련
extension FinancialPlanCreationVC {
    private func setupActions() {
        creationView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        creationView.textFieldArea.infoButton.addAction(UIAction(handler: { [weak self] _ in
            self?.infoButtonTapped()
        }), for: .touchUpInside)
    }
    
    @objc func confirmButtonTapped() {
        if validateInputs() {
            if let newPlan = buttonTapSaveData() {
                creationDelegate?.didCreateFinancialPlan(newPlan)
                
                let tabBar = TabBarController()
                
                tabBar.selectedIndex = 2
                
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    window.rootViewController = tabBar
                    window.makeKeyAndVisible()
                }
            } else {
                print("입력값 오류")
            }
        }
        
        func validateInputs() -> Bool {
            return validateAmount() && validateEndDate()
        }
    }
    
    private func infoButtonTapped() {
        let alert = UIAlertController(title: "정보 보기", message: "자세한 정보를 확인하시겠습니까?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.infoPage()
        })
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func infoPage() {
        guard let selectedPlanType = selectedPlanType else {
            showAlert(message: "선택된 플랜 타입이 없습니다.")
            return
        }
        
        guard let url = URL(string: selectedPlanType.infoLink) else {
            showAlert(message: "유효하지 않은 URL입니다.")
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
    }
}

extension FinancialPlanCreationVC {
    private func setupInitialDate() {
        let today = Date()
        creationView.textFieldArea.startDateField.text = PlanDateModel.dateFormatter.string(from: today)
        creationView.textFieldArea.endDateField.text = PlanDateModel.dateFormatter.string(from: today)
        
        if let startDatePicker = creationView.textFieldArea.startDateField.inputView as? UIDatePicker {
            startDatePicker.date = today
        }
        if let endDatePicker = creationView.textFieldArea.endDateField.inputView as? UIDatePicker {
            endDatePicker.date = today
        }
    }
    
    private func setupDatePickerTarget() {
        if let startDatePicker = creationView.textFieldArea.startDateField.inputView as? UIDatePicker {
            startDatePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        }
        if let endDatePicker = creationView.textFieldArea.endDateField.inputView as? UIDatePicker {
            endDatePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        }
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        if sender == creationView.textFieldArea.startDateField.inputView as? UIDatePicker {
            creationView.textFieldArea.startDateField.text = PlanDateModel.dateFormatter.string(from: sender.date)
        } else if sender == creationView.textFieldArea.endDateField.inputView as? UIDatePicker {
            creationView.textFieldArea.endDateField.text = PlanDateModel.dateFormatter.string(from: sender.date)
        }
    }
}

extension FinancialPlanCreationVC {
    func buttonTapSaveData() -> FinancialPlanDTO? {
        guard let planTitle = creationView.titleTextField.text,
              
                let amountText = creationView.textFieldArea.targetAmountField.text,
              let amount = KoreanCurrencyFormatter.shared.number(from: amountText),
              let depositText = creationView.textFieldArea.currentSavedField.text,
              let deposit = KoreanCurrencyFormatter.shared.number(from: depositText),
              let startDate = PlanDateModel.dateFormatter.date(from: creationView.textFieldArea.startDateField.text ?? ""),
              let endDate = PlanDateModel.dateFormatter.date(from: creationView.textFieldArea.endDateField.text ?? "") else {
            showAlert(message: "모든 필드를 올바르게 입력해주세요.")
            return nil
        }
        
        do {
            let newPlanDTO = try planService.createFinancialPlan(
                title: planTitle,
                amount: amount,
                deposit: deposit,
                startDate: startDate,
                endDate: endDate,
                planType: selectedPlanType ?? .custom,
                isCompleted: false, completionDate: Date.distantFuture
            )
            
            print("새로운 계획이 저장되었습니다: \(newPlanDTO)")
            return newPlanDTO
        } catch {
            showAlert(message: "계획 저장 실패: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - 필드 입력값 유효성 검사
extension FinancialPlanCreationVC {
    private func validateAmount() -> Bool {
        guard let planTitle = creationView.titleTextField.text, (planService.getFinancialPlanByTitle(planTitle) == nil) else {
            showExistingPlanAlert()
            return false
        }
        guard let amountText = creationView.textFieldArea.targetAmountField.text,
              !amountText.isEmpty else {
            showAlert(message: "목표 금액을 입력해주세요.")
            return false
        }
        
        guard let amount = KoreanCurrencyFormatter.shared.number(from: amountText) else {
            showAlert(message: "올바른 금액 형식이 아닙니다.")
            return false
        }
        
        do {
            try planService.validateAmount(amount)
            return true
        } catch ValidationError.negativeAmount {
            showAlert(message: "목표 금액은 0보다 커야 합니다.")
            return false
        } catch {
            showAlert(message: "금액 검증 중 오류가 발생했습니다.")
            return false
        }
    }
    
    private func showExistingPlanAlert() {
        let alert = UIAlertController(title: "알림", message: "같은 제목의 플랜이 있습니다.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "제목수정", style: .cancel, handler: nil)
        
        let goToCurrentPlanAction = UIAlertAction(title: "진행 플랜 보러가기", style: .default) { [weak self] _ in
            self?.navigateToCurrentPlanVC()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(goToCurrentPlanAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func validateEndDate() -> Bool {
        guard let endDateString = creationView.textFieldArea.endDateField.text,
              let startDateString = creationView.textFieldArea.startDateField.text,
              let endDate = PlanDateModel.dateFormatter.date(from: endDateString),
              let startDate = PlanDateModel.dateFormatter.date(from: startDateString) else {
            showAlert(message: "올바른 날짜 형식이 아닙니다.")
            return false
        }
        do {
            try planService.validateDates(start: startDate, end: endDate)
            return true
        } catch {
            showAlert(message: "종료 날짜는 시작 날짜보다 늦어야 합니다.")
            return false
        }
    }
    
    private func navigateToCurrentPlanVC() {
        let currentPlanVC = FinancialPlanCurrentPlanVC(planService: planService)
        navigationController?.pushViewController(currentPlanVC, animated: true)
    }
}

// MARK: - 텍스트필드 관련
extension FinancialPlanCreationVC {
    // 한국화폐에 맞게 세자리 마다 , 처리
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == creationView.titleTextField {
            return true  // 타이틀 텍스트 필드의 경우 입력을 허용
        }
        
        if let currentText = textField.text,
           let textRange = Range(range, in: currentText) {
            let updatedText = currentText.replacingCharacters(in: textRange, with: string)
            let formattedText = KoreanCurrencyFormatter.shared.formatForEditing(updatedText)
            textField.text = formattedText
        }
        return false
    }
    
    // 타이틀 입력시작할 시 프리셋제목 지워주기
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == creationView.titleTextField && textField.text == selectedPlanTitle {
            textField.placeholder = "내 플랜 제목"
            textField.text = ""
            creationView.hideTooltip()
        }
    }
    // 수정사항 없을 시 프리셋제목으로 되돌림
    func textFieldDidEndEditing(_ textField: UITextField) {
        let presetTitle = selectedPlanTitle
        if textField == creationView.titleTextField && textField.text?.isEmpty ?? true {
            textField.text = presetTitle
        }
    }
    //리턴버튼으로 입력완료
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

