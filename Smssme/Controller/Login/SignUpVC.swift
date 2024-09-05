//
//  SignUpVC.swift
//  Smssme
//
//  Created by ahnzihyeon on 8/28/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class SignUpVC: UIViewController, KeyboardEvader {
    
    // 파이어베이스매니저로 뺄 프로퍼티
    var userSession: FirebaseAuth.User? = Auth.auth().currentUser //파이어베이스의 유저 정보를 가져옴(로그인 되있는 상태가 아니면 nil)
    var currentUser: User? // 유저 모델
    // Firestore의 users 컬렉션 참조
    let db = Firestore.firestore()
    
    let signUpView = SignUpView()
    
    // 키보드가 화면 가릴 시 내려가기 위한 설정
    var keyboardScrollView: UIScrollView { return signupView.scrollView}
    
    private let signupView = SignUpView()
    private var selectedCheckBox: UIButton?  // 선택된 체크박스
    
//    private let pickerView = UIPickerView()
    private let incomePickerView = UIPickerView()
    private let locationPickerView = UIPickerView()
    
    // 소득 구간 선택지
    let pickerIncomeData = [
        "1,200만 원 이하",
        "1,200만 원 초과 ~ 4,600만 원 이하",
        "8,800만 원 초과 ~ 1억 5천만 원 이하",
        "1억 5천만 원 초과 ~ 3억 원 이하",
        "3억 원 초과 ~ 5억 원 이하",
        "5억 원 초과 ~ 10억 원 이하",
        "10억 원 초과"]
    
    // 지역 선택지
    let pickerLocationData = ["서울" , "경기도" , "인천" , "부산" , "대구" , "광주" , "대전" , "제주도"]
    
    
    //MARK: - Life cycle
    override func loadView() {
        view = signupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAddtarget()
        configPickerView()
        configToolbar()
        
        registerForKeyboardNotification()
    }
    
    //MARK: - func
    private func setupAddtarget() {
        
        if let user = Auth.auth().currentUser {
            signupView.signupButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        } else {
            // 회원가입 버튼 클릭
            signupView.signupButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        }
        //체크박스 버튼 클릭 시
        signupView.maleCheckBox.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
        signupView.femaleCheckBox.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
        signupView.noneCheckBox.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
    }
    
    
    
    //MARK: - registerUser: 파이어베이스 회원가입
    func registerUser(email: String, password: String, nickname: String, birthday: String, gender: String, income: String, location: String) {
        
        // 회원가입
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            if let error = error {
                print("회원가입에 실패했습니다. 에러명 : \(error.localizedDescription)")
                return
            } else {
                print("로그인 성공!!!")
                
                // 파이어베이스 유저 객체를 가져옴
                guard let uid = authResult?.user.uid else { return }
                
                self.saveUserInfo(uid: uid, nickname: nickname, birthday: birthday, gender: gender, income: income, location: location)
            }
            
            
            self.showAlert(message: "회원가입되었습니다.\n 감사합니다.", AlertTitle: "회원가입 완료", buttonClickTitle: "확인")
            
            let loginVC = LoginVC()
            print("로그인 페이지로 전환")
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    //MARK: - updateUser : 파이어베이스 데이터 업데이트
    func updateUser() {
        guard let user = Auth.auth().currentUser,
              let nickname = signupView.nicknameTextField.text,
              let birthday = signupView.birthdayTextField.text,
              //              let gender = signupView
              let income = signupView.incomeTextField.text,
              let location = signupView.locationTextField.text
        else {
            return
        }
        // Firestore에서 유저 정보 업데이트
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).updateData([
            "nickname": nickname,
            //            "gender": signupView.maleButton.isSelected ? "male" : "female"
            "birthday": birthday,
            "income": income,
            "location": location
        ]) { error in
            if let error = error {
                print("유저 정보 수정 실패: \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: - saveUserInfo: 사용자 정보 저장 파이어베이스에 저장
    func saveUserInfo(uid: String, nickname: String, birthday: String, gender: String, income: String, location: String) {
        
        // 저장할 데이터 정의
        let userData: [String: Any] = [
            "nickname": nickname,
            "birthday": birthday,
            "gender": gender,
            "income": income,
            "location": location,
            "email": Auth.auth().currentUser?.email ?? ""
        ]
        
        // users 컬렉션에 UID를 키로 데이터 저장
        db.collection("users").document(uid).setData(userData) { error in
            if let error = error {
                print("Error saving user data: \(error.localizedDescription)")
            } else {
                print("User data saved successfully!")
            }
        }
    }
    
    
    
    //MARK: - @objc 회원 가입/ 수정 버튼 클릭
    @objc private func signUpButtonTapped() {
        print("회원가입 클릭!!!!")
        
        guard let email = signupView.emaiTextField.text, !email.isEmpty,
              let password = signupView.passwordTextField.text, !password.isEmpty,
              let nickname = signupView.nicknameTextField.text, !nickname.isEmpty,
              let birthday = signupView.birthdayTextField.text, !birthday.isEmpty,
              //              let genders = signupView.femaleCheckBox., !genders.isEmpty,
              let income = signupView.incomeTextField.text, !income.isEmpty,
              let location = signupView.locationTextField.text, !location.isEmpty
                
        else {
            showAlert(message: "모든 항목을 입력해주세요.", AlertTitle: "입력 오류", buttonClickTitle: "확인")
            return }
        
        registerUser(email: email, password: password, nickname: nickname, birthday: birthday, gender: "선택 안함", income: income, location: location)
        
        showAlert(message: "회원가입이 완료되었습니다.", AlertTitle: "회원가입 완료", buttonClickTitle: "확인")
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func editButtonTapped() {
        print("회원정보 수정 클릭!!!!")
        
        guard let email = signupView.emaiTextField.text, !email.isEmpty,
              let password = signupView.passwordTextField.text, !password.isEmpty,
              let nickname = signupView.nicknameTextField.text, !nickname.isEmpty,
              let birthday = signupView.birthdayTextField.text, !birthday.isEmpty,
              //              let genders = signupView.femaleCheckBox., !genders.isEmpty,
              let income = signupView.incomeTextField.text, !income.isEmpty,
              let location = signupView.locationTextField.text, !location.isEmpty
                
        else {
            showAlert(message: "모든 항목을 입력해주세요.", AlertTitle: "입력 오류", buttonClickTitle: "확인")
            return }
        
        updateUser()
        
        showSnycAlert(message: "회원정보 수정이 완료되었습니다.", AlertTitle: "회원정보 수정 완료", buttonClickTitle: "확인") {
            self.navigationController?.popViewController(animated: true)
            let mypageView = MypageView()
        }
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
            
            if let tagType = GenderTags(rawValue: checkBox.tag) {
                switch tagType {
                case .male:
                    print("tag: \(checkBox.tag) - 남성 체크박스 선택됨")
                case .female:
                    print("tag: \(checkBox.tag) - 여성 체크박스 선택됨")
                case .none:
                    print("tag: \(checkBox.tag) - 선택안함 체크박스 선택됨")
                }
            }
        }
    }
    
    // 피커뷰 "완료" 클릭 시 데이터를 textfield에 입력 후 입력창 내리기
    @objc func donePicker() {
        // 소득 구간
        let incomeRow = incomePickerView.selectedRow(inComponent: 0)
        signupView.incomeTextField.text = pickerIncomeData[incomeRow]
        
        // 지역
        let locationRow = locationPickerView.selectedRow(inComponent: 0)
        signupView.locationTextField.text = pickerLocationData[locationRow]
        
        // 텍스트필드 입력 마치고 키보드 숨기기
        signupView.incomeTextField.resignFirstResponder()
        signupView.locationTextField.resignFirstResponder()
        
        // 선택된 값 출력
        print("선택한 소득구간: \(signupView.incomeTextField.text ?? "")")
        print("선택한 위치: \(signupView.locationTextField.text ?? "")")
    }
    
    // 피커뷰 "취소" 클릭 시 textfield의 텍스트 값을 nil로 처리 후 입력창 내리기
    @objc func cancelPicker() {
        signupView.incomeTextField.text = nil
        signupView.locationTextField.text = nil
        signupView.incomeTextField.resignFirstResponder()
    }
}


//MARK: - extension - PickerView
extension SignUpVC: UIPickerViewDelegate, UIPickerViewDataSource {
    private func configPickerView() {
        // 소득구간
        incomePickerView.delegate = self
        incomePickerView.dataSource = self
        signupView.incomeTextField.inputView = incomePickerView //텍스트필드 눌렀을 때 뜨는 뷰(inputView)
        
        
        // 지역
        locationPickerView.delegate = self
        locationPickerView.dataSource = self
        signupView.locationTextField.inputView = locationPickerView
        
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
        signupView.incomeTextField.text = pickerIncomeData[row]
        signupView.locationTextField.text = pickerLocationData[row]
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
        
        signupView.incomeTextField.inputAccessoryView = toolBar
        signupView.locationTextField.inputAccessoryView = toolBar
        
    }
}

