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
    var userData = UserData()
    
    // 파이어베이스매니저로 뺄 프로퍼티
    var userSession: FirebaseAuth.User? = Auth.auth().currentUser //파이어베이스의 유저 정보를 가져옴(로그인 되있는 상태가 아니면 nil)
    //    var currentUser: User? // 유저 모델
    //    // Firestore의 users 컬렉션 참조
    //    let db = Firestore.firestore()
    
    
    private let signupView = SignUpView()
    private var selectedCheckBox: UIButton?  // 선택된 체크박스
    
    private let isLocationPickerView = true
    private let incomePickerView = UIPickerView()
    private let locationPickerView = UIPickerView()
    
    
    // 키보드가 화면 가릴 시 내려가기 위한 설정
    var keyboardScrollView: UIScrollView { return signupView.scrollView}
    
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
    override func loadView() {
        view = signupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        incomePickerView.tag = 1
        locationPickerView.tag = 2
        
        setupAddtarget()
        configPickerView()
        configToolbar()
        datePickerToolbar()
        
        registerForKeyboardNotification()
    }
    
    //MARK: - func
    private func setupAddtarget() {
        
        if let user = Auth.auth().currentUser {
            signupView.signupButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        } else {
            // 회원가입 버튼 클릭
//            signupView.signupButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
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
            
            if let error = error as NSError? {
                
                switch AuthErrorCode(rawValue: error.code) {
                case .invalidEmail:
                    self.showAlert(message: "잘못된 이메일 형식입니다. \n비밀번호 찾기 시 해당 메일로 인증이 진행되니 \n실제 사용 이메일을 기입해주세요.", AlertTitle: "이메일 형식 오류", buttonClickTitle: "확인")
                case .emailAlreadyInUse:
                    self.showAlert(message: "이미 사용 중인 이메일입니다.", AlertTitle: "이메일 중복", buttonClickTitle: "확인")
                case .weakPassword:
                    self.showAlert(message: "비밀번호 보안이 약합니다. \n비밀번호는 최소 6자리 이상이여야 합니다.", AlertTitle: "비밀번호 경고", buttonClickTitle: "확인")
                case .networkError:
                    self.showAlert(message: "네트워크 연결 상태를 확인해주세요.", AlertTitle: "네트워크 연결 불안정", buttonClickTitle: "확인")
                default:
                    self.showAlert(message: error.localizedDescription, AlertTitle: "에러 발생", buttonClickTitle: "확인")
                }
                return
            } else {
                print("로그인 성공!!!")
                // 파이어베이스 유저 객체를 가져옴
                guard let uid = authResult?.user.uid else { return }
                
                //                self.saveUserInfo(uid: uid, nickname: nickname, birthday: birthday, gender: gender, income: income, location: location)
                
                FirebaseFirestoreManager.shared.saveUserData(uid: uid, userData: self.userData) { saveResult in
                    switch saveResult {
                    case .success:
                        print("사용자 정보 저장 성공")
                    case .failure(let error):
                        print("사용자 정보 저장 실패: \(error.localizedDescription)")
                    }
                    self.showSnycAlert(message: "회원가입되었습니다.\n 감사합니다.", AlertTitle: "회원가입 완료", buttonClickTitle: "확인") {
                        let loginVC = LoginVC()
                        print("로그인 페이지로 전환")
                        SplashViewController().showMainVC()
                    }
                }
            }
        }
        

//                FirebaseFirestoreManager.shared.saveUserData(uid: uid, userData: self.userData) { saveResult in
//                    switch saveResult {
//                    case .success:
//                        print("사용자 정보 저장 성공")
//                    case .failure(let error):
//                        print("사용자 정보 저장 실패: \(error.localizedDescription)")
//                    }
//                }
        
//        func saveUserInfo(uid: String, nickname: String, birthday: String, gender: String, income: String, location: String) {
//            
//            // 저장할 데이터 정의
//            let userData: [String: Any] = [
//                "nickname": nickname,
//                "birthday": birthday,
//                "gender": gender,
//                "income": income,
//                "location": location,
//                "email": Auth.auth().currentUser?.email ?? ""
//            ]
//            
//            // users 컬렉션에 UID를 키로 데이터 저장
//            db.collection("users").document(uid).setData(userData) { error in
//                if let error = error {
//                    print("Error saving user data: \(error.localizedDescription)")
//                } else {
//                    print("User data saved successfully!")
//                }
//            }
//        }
        
        
    }
    
    //MARK: - @objc 회원 가입/ 수정 버튼 클릭
    
    @objc private func editButtonTapped() {
        print("회원정보 수정 클릭!!!!")
        
        guard let email = signupView.emaiTextField.text, !email.isEmpty,
              let nickname = signupView.nicknameTextField.text, !nickname.isEmpty,
              let birthday = signupView.birthdayTextField.text, !birthday.isEmpty,
              let gender = signupView.maleCheckBox.isSelected ? "male" : signupView.femaleCheckBox.isSelected ? "female" : signupView.noneCheckBox.isSelected ? "none" : nil , !gender.isEmpty,
              let income = signupView.incomeTextField.text, !income.isEmpty,
              let location = signupView.locationTextField.text, !location.isEmpty
                
        else {
            showAlert(message: "모든 항목을 입력해주세요.", AlertTitle: "입력 오류", buttonClickTitle: "확인")
            return
        }
        
        guard let user = Auth.auth().currentUser,
              let nickname = signupView.nicknameTextField.text,
              let birthday = signupView.birthdayTextField.text,
              let income = signupView.incomeTextField.text,
              let location = signupView.locationTextField.text
        else {
            return
        }
        // Firestore에서 유저 정보 업데이트
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).updateData([
            "nickname": nickname,
            "gender": signupView.maleCheckBox.isSelected ? "male" : signupView.femaleCheckBox.isSelected ? "female" : "none",
            "birth": birthday,
            "income": income,
            "location": location
        ]) { error in
            if let error = error {
                print("유저 정보 수정 실패: \(error.localizedDescription)")
            }
        }
        
        let mypageView = MypageView()
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
            
            selectedCheckBox?.tag
            
            if let tagType = GenderTags(rawValue: checkBox.tag) {
                switch tagType {
                case .male:
                    print("tag: \(GenderTags(rawValue: 1)) - 남성 체크박스 선택됨")
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
        if isLocationPickerView {
            let locationRow = locationPickerView.selectedRow(inComponent: 0)
            signupView.locationTextField.text = pickerLocationData[locationRow]
            print("선택한 위치: \(signupView.locationTextField.text ?? "")")
        } else {
            let incomeRow = incomePickerView.selectedRow(inComponent: 0)
            signupView.incomeTextField.text = pickerIncomeData[incomeRow]
            print("선택한 소득구간: \(signupView.incomeTextField.text ?? "")")
        }
        
        // 텍스트필드 입력 마치고 키보드 숨기기
        signupView.incomeTextField.resignFirstResponder()
        signupView.locationTextField.resignFirstResponder()
    }
    
    // 피커뷰 "취소" 클릭 시 textfield의 텍스트 값을 nil로 처리 후 입력창 내리기
    @objc func cancelPicker() {
        signupView.incomeTextField.text = nil
        signupView.locationTextField.text = nil
        signupView.incomeTextField.resignFirstResponder()
        signupView.locationTextField.resignFirstResponder()
    }
    
    
    //MARK: - 데이트피커뷰 선택 시
    @objc func dateChange(_ sender: UIDatePicker) {
        signupView.birthdayTextField.text = dateFormat(date: sender.date)
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
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(self.dateDonePicker))
        
        toolBar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        signupView.birthdayTextField.inputAccessoryView = toolBar
    }
    
    @objc
    private func dateCancelPicker() {
        signupView.birthdayTextField.text = nil
        signupView.birthdayTextField.resignFirstResponder()
    }
    
    @objc func dateDonePicker() {
        signupView.birthdayTextField.text = dateFormat(date: signupView.datePickerView.date)
        signupView.birthdayTextField.resignFirstResponder()
    }
}


//MARK: - extension - PickerView
extension SignUpVC: UIPickerViewDelegate, UIPickerViewDataSource {
    private func configPickerView() {
        
        // 생년월일
        signupView.birthdayTextField.inputView = signupView.datePickerView
        signupView.datePickerView.addTarget(self, action: #selector(dateChange), for: .valueChanged)
        
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
        if pickerView == self.incomePickerView {
            signupView.incomeTextField.text = pickerIncomeData[row]
        } else {
            signupView.locationTextField.text = pickerLocationData[row]
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
        
        signupView.incomeTextField.inputAccessoryView = toolBar
        signupView.locationTextField.inputAccessoryView = toolBar
    }
}

