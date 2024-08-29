//
//  LoginVC.swift
//  Smssme
//
//  Created by ahnzihyeon on 8/27/24.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {
    var handle: AuthStateDidChangeListenerHandle?
    
    private let loginVeiw = LoginView()
    
    override func loadView() {
        view = loginVeiw
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAddtarget()
        
    }
    
    ///인증상태 수신 대기 - 리스터 연결
    ///각각의 앱 뷰에서 앱에 로그인한 사용자에 대한 정보를 얻기 위해 FIRAuth 객체와 리스너를 연결합니다. 이 리스너는 사용자의 로그인 상태가 변경될 때마다 호출됩니다.
    override func viewWillAppear(_ animated: Bool) {
        // [START auth_listener]
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            // [START_EXCLUDE]
            //          self.setTitleDisplay(user)
            //          self.tableView.reloadData()
        }
    }
    
    ///인증상태 수신 대기 - 리스터 분리
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    
    func setupAddtarget() {
        //체크박스 버튼 클릭 시
        loginVeiw.autoLoginCheckBox.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
        
        loginVeiw.rememberIDCheckBox.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
        
        
        // 로그인 버튼 클릭 시
        loginVeiw.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        // 회원가입 버튼 클릭 시 회원가입 뷰로 이동
        loginVeiw.signupButton.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
        
        // 비회원 로그인 시
        loginVeiw.unLoginButton.addTarget(self, action: #selector(unloginButtonTapped), for: .touchUpInside)
    }
    
    ///사용자 정보 가져오기
    ///사용자가 로그인되면 사용자에 대한 정보를 가져올 수 있습니다. 예를 들어 인증 상태 리스너에서 다음을 수행합니다.
    //    if let user = user {
    //      let uid = user.uid
    //      let email = user.email
    //      let photoURL = user.photoURL
    //      var multiFactorString = "MultiFactor: "
    //      for info in user.multiFactor.enrolledFactors {
    //        multiFactorString += info.displayName ?? "[DispayName]"
    //        multiFactorString += " "
    //      }
    //      // [START_EXCLUDE]
    //      let emailLabel = cell?.viewWithTag(1) as? UILabel
    //      let userIDLabel = cell?.viewWithTag(2) as? UILabel
    //      let profileImageView = cell?.viewWithTag(3) as? UIImageView
    //      let multiFactorLabel = cell?.viewWithTag(4) as? UILabel
    //      emailLabel?.text = email
    //      userIDLabel?.text = uid
    //      multiFactorLabel?.text = multiFactorString
    //      if isMFAEnabled {
    //        multiFactorLabel?.isHidden = false
    //      } else {
    //        multiFactorLabel?.isHidden = true
    //      }
    //
    //      struct last {
    //        static var photoURL: URL? = nil
    //      }
    //      last.photoURL = photoURL // to prevent earlier image overwrites later one.
    //      if let photoURL = photoURL {
    //        DispatchQueue.global(qos: .default).async {
    //          let data = try? Data(contentsOf: photoURL)
    //          if let data = data {
    //            let image = UIImage(data: data)
    //            DispatchQueue.main.async {
    //              if photoURL == last.photoURL {
    //                profileImageView?.image = image
    //              }
    //            }
    //          }
    //        }
    //      } else {
    //        profileImageView?.image = UIImage(named: "ic_account_circle")
    //      }
    //      // [END_EXCLUDE]
    //    }
    
    
    //MARK: - @objc 로그인
    ///기존 사용자 로그인
    ///기존 사용자가 자신의 이메일 주소와 비밀번호를 사용해 로그인할 수 있는 양식을 만듭니다. 사용자가 양식을 작성하면 signIn 메서드를 호출합니다.
    @objc func loginButtonTapped() {
        guard let email = loginVeiw.emailTextField.text, !email.isEmpty,
              let password = loginVeiw.passwordTextField.text, !password.isEmpty else {
            showAlert(message: "이메일과 패스워드를 입력해주세요.", AlertTitle: "입력 정보 오류", buttonClickTitle: "확인")
            return
        }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            guard let self = self else { return }
            // 에러가 나거나 유저가 없을 경우
            if let error = error, user == nil {
                
                showAlert(message: "\(error)", AlertTitle: "로그인 실패", buttonClickTitle: "확인")
                
            } else {
                // 성공이면 화면전환하고 프로필 가져오기
                //                self.getUserProfile()
                showAlert(message: "안녕하세요,\n 로그인되었습니다.", AlertTitle: "로그인 성공", buttonClickTitle: "확인")
                
                let MypageVC = MypageViewController()
                print("로그인하고 페이지 전환")
                navigationController?.pushViewController(MypageVC, animated: true)
            }
        }
    }
    
    
    //MARK: - 로그인 체크박스
    @objc func checkBoxTapped(_ sender: UIButton) {
        sender.isSelected.toggle() // 선택 상태를 반전시킴
        // 선택 상태에 따라 동작 추가 가능
        if sender.isSelected {
            print("체크박스 선택됨")
        } else {
            print("체크박스 선택 해제됨")
        }
    }
    
    
    //MARK: - @objc 회원가입
    @objc private func signupButtonTapped() {
        let signupVC = SignUpVC()
        navigationController?.pushViewController(signupVC, animated: true)
    }
    
    
    //MARK: - @objc 비회원 로그인
    @objc private func unloginButtonTapped() {
        // 아직 메인 페이지 뷰컨이 없는 상태라 혜정님 뷰컨으로 임시 연결
        let vc = FinancialPlanSelectionVC(financialPlanSelectionView: FinancialPlanSelectionView())
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

