//
//  NickNameVC.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/8/24.
//

import UIKit

// 닉네임 생년월일
class NickNameVC: UIViewController {
    private let nicknameView = NickNameView()
    private var textField = UITextField()
    var userData = UserData()
    
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = nicknameView
        
        datePickerToolbar()
        
        nicknameView.nicknameTextField.delegate = self
        nicknameView.birthdayTextField.delegate = self
        
        
        // 생년월일
        nicknameView.birthdayTextField.inputView = nicknameView.datePickerView
        nicknameView.datePickerView.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        
        
        nicknameView.nicknameTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        nicknameView.birthdayTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        
        nicknameView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    
    //MARK: - @objc
    @objc func nextButtonTapped() {
        userData.nickname = nicknameView.nicknameTextField.text
        userData.birth = nicknameView.birthdayTextField.text
        
        let incomeAndLocationVC = IncomeAndLocationVC()
        incomeAndLocationVC.userData = userData //데이터 전달
        navigationController?.pushViewController(incomeAndLocationVC, animated: true)
    }
    
    //MARK: - 데이트피커뷰 선택 시
    @objc func dateChange(_ sender: UIDatePicker) {
        nicknameView.birthdayTextField.text = dateFormat(date: sender.date)
        
        guard
            let nickname = nicknameView.nicknameTextField.text, !nickname.isEmpty,
            let birth = nicknameView.birthdayTextField.text, !birth.isEmpty
        else {
            nicknameView.nextButton.backgroundColor = .systemGray5
            nicknameView.nextButton.isEnabled = false
            return
        }
        nicknameView.nextButton.backgroundColor = .systemBlue
        nicknameView.nextButton.isEnabled = true
    }
    
    // 텍스트 필드에 들어갈 텍스트를 DateFormatter 변환
    private func dateFormat(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy / MM / dd"
        
        return formatter.string(from: date)
    }
    
    // 데이트피커뷰 툴바 구성
    private func datePickerToolbar() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(self.dateCancelPicker))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)  //취소~완료 간의 거리
        
        let doneButton = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(self.dateDonePicker))
        
        toolBar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        nicknameView.birthdayTextField.inputAccessoryView = toolBar
    }
    
    
    @objc
    private func dateCancelPicker() {
        nicknameView.birthdayTextField.text = nil
        nicknameView.birthdayTextField.resignFirstResponder()
    }
    
    @objc func dateDonePicker() {
        nicknameView.birthdayTextField.text = dateFormat(date: nicknameView.datePickerView.date)
        nicknameView.birthdayTextField.resignFirstResponder()
    }
}



//MARK: - UITextField extension
extension NickNameVC: UITextFieldDelegate {
    
    // 입력 시작 시
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    // 입력 끝날 시
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.systemGray5.cgColor
    }
    
    // 엔터 누르면 포커스 이동 후 키보드 내림
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField ==  nicknameView.nicknameTextField {
            nicknameView.birthdayTextField.becomeFirstResponder()
        } else if textField == nicknameView.birthdayTextField {
            nicknameView.birthdayTextField.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField.text!.count < 10 else { return false } // 10 글자로 제한
        return true
    }
    
    // 모든 내용 입력돼야 버튼 활성화
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        
        // 공백 입력 방지 -> 중간에 입력할 시에는 적용되는 문제 있음
        textField.text = textField.text?.trimmingCharacters(in: .whitespaces)
        
        if let nickname = nicknameView.nicknameTextField.text,
           let birth = nicknameView.birthdayTextField.text,
           nickname.count > 1 && nickname.count < 11 &&  !birth.isEmpty {
            nicknameView.nextButton.backgroundColor = .systemBlue
            nicknameView.nextButton.isEnabled = true
        }
        else {
            nicknameView.nextButton.backgroundColor = .systemGray5
            nicknameView.nextButton.isEnabled = false
            return
        }
    }
    
}
