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
    // 키보드가 화면 가릴 시 내려가기 위한 설정
    var keyboardScrollView: UIScrollView { return signupView.scrollView}
    
    private let signupView = SignUpView()
    private var selectedCheckBox: UIButton?  // 선택된 체크박스
    
    private let pickerView = UIPickerView()
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
        // 회원가입 버튼 클릭
        signupView.signupButton.addTarget(self, action: #selector(signupViewButtonTapped), for: .touchUpInside)
        
        //체크박스 버튼 클릭 시
        signupView.maleCheckBox.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
        signupView.femaleCheckBox.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
        signupView.noneCheckBox.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
    }
    
    
    
    //MARK: - @objc 회원 가입
    @objc private func signupViewButtonTapped() {
        print("회원가입 클릭!!!!")
        guard let email = signupView.emaiTextField.text, !email.isEmpty,
              let password = signupView.passwordTextField.text, !password.isEmpty,
              let nickname = signupView.nicknameTextField.text, !nickname.isEmpty,
              let birthday = signupView.birthdayTextField.text, !birthday.isEmpty,
              //              let genders = signupView.check.text, !genders.isEmpty,
              let income = signupView.incomeTextField.text, !income.isEmpty,
              let location = signupView.locationTextField.text, !location.isEmpty
        else {
            showAlert(message: "모든 항목을 입력해주세요.", AlertTitle: "입력 오류", buttonClickTitle: "확인")
            return }
        
        ///파이어베이스 회원가입
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            
            if let error = error {
                print("회원가입에 실패했습니다. 에러명 : \(error.localizedDescription)")
                return
            } else {
                print("로그인 성공!!!")
                // 데이터 추가
                //                let db = Firestore.firestore()
                //                var ref: DocumentReference? = nil
                //                ref = db.collection("users").addDocument(data: ["아이디(이메일)": email,
                //                                                                "닉네임": nickname,
                //                                                                "이메일": email,
                //                                                                "uid": result!.user.uid]) { (error) in
                //
                //                    if error != nil {
                //                        print(error?.localizedDescription ?? "사용자 데이터 저장 오류")
                //                    } else {
                //                        print("데이터 추가", ref!.documentID)
                //                    }
                //                }
            }
            
            //TODO: - 회원가입 완료 시 alert 띄우고 화면 전환
            self.showAlert(message: "회원가입되었습니다.\n 감사합니다.", AlertTitle: "회원가입 완료", buttonClickTitle: "확인")
            
            // 아직 메인 페이지 뷰컨이 없는 상태라 혜정님 뷰컨으로 임시 연결
            let vc = FinancialPlanSelectionVC()
            print("로그인하고 페이지 전환")
            self.navigationController?.pushViewController(vc, animated: true)
            
            //action //유저 회원가입 정보 로그인 여부에 전달
            //                let data = ["email":email,"name":name,"password":password,"uid":user.uid]    //회원가입 정보를 데이터에 저장
            //                Firestore.firestore().collection("user")    //"user" 데이터베이스에 저장
            //                    .document(user.uid)                     //문서명 유저.uid로 설정
            //                    .setData(data) { _ in                   //데이터 저장 시 변경 사항
            //                        print("DEBUG : 유저정보가 업로드 되었습니다. 프로필 사진 변경")
            //                    }
        }
    }
    //    }
    
    
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
        let row = pickerView.selectedRow(inComponent: 0)
        pickerView.selectRow(row, inComponent: 0, animated: false)
        signupView.incomeTextField.text = pickerIncomeData[row]
        signupView.incomeTextField.resignFirstResponder()
        print("선택한 소득구간: \(signupView.incomeTextField.text)")
    }
    
    // 피커뷰 "취소" 클릭 시 textfield의 텍스트 값을 nil로 처리 후 입력창 내리기
    @objc func cancelPicker() {
        signupView.incomeTextField.text = nil
        signupView.incomeTextField.resignFirstResponder()
    }
}


//MARK: - extension
extension SignUpVC: UIPickerViewDelegate, UIPickerViewDataSource {
    private func configPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        signupView.incomeTextField.inputView = pickerView //텍스트필드 눌렀을 때 뜨는 뷰(inputView)
        //        signupView.locationTextField.inputView = pickerView
    }
    
    // 피커뷰의 갯수
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // 피커뷰에 표시될 항목 수
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerIncomeData.count
    }
    // 특정 위치(row)번째 문자열 반환
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerIncomeData[row]
    }
    // 텍스트필드의 텍스트를 선택된 문자열로 변환
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        signupView.incomeTextField.text = pickerIncomeData[row]
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
        
    }
}

