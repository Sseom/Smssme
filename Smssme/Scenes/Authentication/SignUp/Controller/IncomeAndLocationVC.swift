//
//  IncomeAndLocationVC.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/8/24.
//

import UIKit
import SafariServices

// 성별
class IncomeAndLocationVC: UIViewController {
    private let emailView = EmailView()
    private let passwordView = PasswordView()
    private let nicknameView = NickNameView()
    private let incomeAndLocationView = IncomeAndLocationView()
    private var selectedGender: String = ""
    
    private var selectedCheckBox: UIButton?
    private let incomePickerView = UIPickerView()
    private let locationPickerView = UIPickerView()
    
    var userData = UserData()
    
    // 소득 구간 선택지
    let pickerIncomeData = [
        "1,200만 원 이하",
        "1,200만 원 초과 ~ 4,600만 원 이하",
        "4,600만 원 초과 ~ 8,800만 원 이하",
        "8,800만 원 초과 ~ 1억 5천만 원 이하",
        "1억 5천만 원 초과 ~ 3억 원 이하",
        "3억 원 초과 ~ 5억 원 이하",
        "5억 원 초과 ~ 10억 원 이하",
        "10억 원 초과"]
    
    // 지역 선택지
    let pickerLocationData = ["서울" , "경기도", "인천" , "부산" , "강원도" ,"대구", "전라북도", "전라남도", "충청북도", "충청남도", "경상북도", "경상남도", "광주", "울산", "대전" , "제주도"]
    
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = incomeAndLocationView
        incomeAndLocationView.agreementTextVeiw.delegate = self
        
        incomePickerView.tag = 1
        locationPickerView.tag = 2
        
        setupAddtarget()
        configPickerView()
        configToolbar()
        
        
    }
    
    //MARK: - func
    private func setupAddtarget() {
        // 체크박스 버튼 클릭 시
        incomeAndLocationView.maleCheckBox.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
        incomeAndLocationView.femaleCheckBox.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
        incomeAndLocationView.noneCheckBox.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
        
        // 다음 버튼 클릭 시
        incomeAndLocationView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
    }
    
    // 버튼 활성화를 위한 유효성 검증
    private func validateForm() {
        selectedGender = incomeAndLocationView.maleCheckBox.isSelected ? "male" : incomeAndLocationView.femaleCheckBox.isSelected ? "female" :
        incomeAndLocationView.noneCheckBox.isSelected ? "none" : ""
        let income = incomeAndLocationView.incomeTextField.text ?? ""
        let location = incomeAndLocationView.locationTextField.text ?? ""
        
        print("수입 입력 여부: \(income)")
        print("지역 입력 여부: \(location)")
        print("성별 선택 여부: \(selectedGender)")
        
        if !selectedGender.isEmpty && !income.isEmpty && !location.isEmpty {
            incomeAndLocationView.nextButton.backgroundColor = .systemBlue
            incomeAndLocationView.nextButton.isEnabled = true
        } else {
            incomeAndLocationView.nextButton.backgroundColor = .systemGray5
            incomeAndLocationView.nextButton.isEnabled = false
        }
    }
    
    //MARK: - @objc
    @objc func nextButtonTapped() {
        userData.gender = selectedGender
        userData.income = incomeAndLocationView.incomeTextField.text
        userData.location = incomeAndLocationView.locationTextField.text
        
        // 모든 정보가 입력되었으므로 Firebase에 저장
        FirebaseAuthManager.shared.registerUser(email: userData.email ?? "", password: userData.password ?? "") { result in
            switch result {
            case .success(let uid):
                FirebaseFirestoreManager.shared.saveUserData(uid: uid, userData: self.userData) { saveResult in
                    switch saveResult {
                    case .success:
                        print("사용자 정보 저장 성공")
                    case .failure(let error):
                        print("사용자 정보 저장 실패: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                print("회원가입 실패: \(error.localizedDescription)")
            }
        }
        
        showSnycAlert(message: "회원가입이 완료되었습니다. \n로그인해주세요.", AlertTitle: "회원가입 성공", buttonClickTitle: "확인") {
            SplashViewController().showLoginVC()
        }
        
        
    }
    
    // 피커뷰 "완료" 클릭 시 데이터를 textfield에 입력 후 입력창 내리기
    @objc func donePicker() {
        if incomeAndLocationView.locationTextField.isFirstResponder {
            let locationRow = locationPickerView.selectedRow(inComponent: 0)
            incomeAndLocationView.locationTextField.text = pickerLocationData[locationRow]
        } else if incomeAndLocationView.incomeTextField.isFirstResponder {
            let incomeRow = incomePickerView.selectedRow(inComponent: 0)
            incomeAndLocationView.incomeTextField.text = pickerIncomeData[incomeRow]
        }
        
        // 텍스트필드 입력 마치고 키보드 숨기기
        incomeAndLocationView.incomeTextField.resignFirstResponder()
        incomeAndLocationView.locationTextField.resignFirstResponder()
        
        validateForm()
    }
    
    // 피커뷰 "취소" 클릭 시 textfield의 텍스트 값을 nil로 처리 후 입력창 내리기
    @objc func cancelPicker() {
        incomeAndLocationView.incomeTextField.text = nil
        incomeAndLocationView.locationTextField.text = nil
        incomeAndLocationView.incomeTextField.resignFirstResponder()
        incomeAndLocationView.locationTextField.resignFirstResponder()
    }
    
    
    //MARK: - 성별 체크박스
    @objc func checkBoxTapped(_ checkBox: UIButton) {
        // 이미 다른 체크박스가 선택된 상태에서 새로운 체크박스를 선택하려는 경우
        if let selected = selectedCheckBox, selected != checkBox {
            showAlert(message: "중복선택이 불가합니다.", AlertTitle: "경고", buttonClickTitle: "확인")
            return
        }
        
        // 현재 선택된 체크박스가 동일한 경우 선택 해제
        if selectedCheckBox == checkBox {
            checkBox.isSelected = false
            selectedCheckBox = nil
            print("체크박스 선택 해제됨")
        } else {
            // 새로운 체크박스를 선택
            checkBox.isSelected = true
            selectedCheckBox = checkBox
        }
        validateForm()
    }
}


//MARK: - extension - TextView
extension IncomeAndLocationVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        let safariVC = SFSafariViewController(url: URL)
        present(safariVC, animated: true, completion: nil)
        return false
    }
}

//MARK: - extension - PickerView
extension IncomeAndLocationVC: UIPickerViewDelegate, UIPickerViewDataSource {
    private func configPickerView() {
        
        // 소득구간
        incomePickerView.delegate = self
        incomePickerView.dataSource = self
        incomeAndLocationView.incomeTextField.inputView = incomePickerView //텍스트필드 눌렀을 때 뜨는 뷰(inputView)
        
        // 지역
        locationPickerView.delegate = self
        locationPickerView.dataSource = self
        incomeAndLocationView.locationTextField.inputView = locationPickerView
        
    }
    
    // 피커뷰의 갯수
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // 피커뷰에 표시될 항목 수
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.incomePickerView {
            return pickerIncomeData.count
        } else if pickerView == self.locationPickerView {
            return pickerLocationData.count
        } else {
            return 0
        }
    }
    
    // 특정 위치(row)번째 문자열 반환
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == self.incomePickerView {
            return pickerIncomeData[row]
        } else if pickerView == self.locationPickerView {
            return pickerLocationData[row]
        } else {
            return ""
        }
    }
    
    // 텍스트필드의 텍스트를 선택된 문자열로 변환
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(pickerView)
        if pickerView == self.incomePickerView {
            incomeAndLocationView.incomeTextField.text = pickerIncomeData[row]
        } else {
            incomeAndLocationView.locationTextField.text = pickerLocationData[row]
        }
    }
    
    // 툴바 구성
    private func configToolbar() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(self.cancelPicker))
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)  //취소~완료 간의 거리
        
        let doneButton = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(self.donePicker))
        
        toolBar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        incomeAndLocationView.incomeTextField.inputAccessoryView = toolBar
        incomeAndLocationView.locationTextField.inputAccessoryView = toolBar
    }
}

