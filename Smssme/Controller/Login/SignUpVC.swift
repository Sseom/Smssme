//
//  SignUpVC.swift
//  Smssme
//
//  Created by ahnzihyeon on 8/28/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpVC: UIViewController {
    
    private let signupView = SignUpView()
    
    // 피커뷰에 보여줄 테스트 데이터 -> 이것의 위치는 어디가 좋을지..?
    let pickerLocationData = ["서울" , "경기도" , "인천" , "부산" , "대구" , "광주" , "대전" , "제주도"]
    
    
    override func loadView() {
        view = signupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signupView.signupButton.addTarget(self, action: #selector(signupViewButtonTapped), for: .touchUpInside)
    }
    
    
    //MARK: - @objc 회원 가입
    @objc private func signupViewButtonTapped() {
        print("회원가입 클릭!!!!")
        guard let email = signupView.emaiTextField.text, !email.isEmpty,
              let password = signupView.passwordTextField.text, !password.isEmpty
//              let nickname = signupView.nicknameTextField.text, !nickname.isEmpty,
//              let birthday = signupView.birthdayTextField.text, !birthday.isEmpty,
//              let genders = signupView.genderSegment.text, !genders.isEmpty,
//              let income = signupView.incomePicker.text, !income.isEmpty,
//              let location = signupView.locationPicker.text, !location.isEmpty
        else { return }
        
        ///파이어베이스 회원가입
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            
            if let error = error {
                print("회원가입에 실패했습니다. 에러명 : \(error)")
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
            let vc = FinancialPlanSelectionVC(financialPlanSelectionView: FinancialPlanSelectionView())
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
        
        //MARK: - extension
        //    extension SignUpVC: UITextFieldDelegate {
        //
        //    }
        
        
        //extension SignUpVC: UIPickerViewDelegate, UIPickerViewDataSource {
        //    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //
        //    }
        //
        //    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //        <#code#>
        //    }
        //
        //
        //}
    }
