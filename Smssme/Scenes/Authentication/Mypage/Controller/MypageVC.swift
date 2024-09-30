//
//  MypageVC.swift
//  Smssme
//
//  Created by ahnzihyeon on 8/29/24.
//

import FirebaseAuth
import FirebaseFirestore
import SafariServices
import SnapKit
import UIKit


class MypageVC: UIViewController {
    
    private let mypageView = MypageView()
    private let mypageViewCell = MypageViewCell()
    private var userData = UserData()
    private var user = Auth.auth().currentUser
    var isLoggedIn: Bool = false
    
    // section headers
    private let headers: [String] = ["계정 관리", "설정", "서비스 안내", "기타"]
    
    // 각 cell에 들어갈 정보
    private let data = [
        ["내 정보 수정", "비밀번호 재설정"],
        ["알림 설정"],
        ["개인정보처리 방침"],
        ["앱 버전", "로그아웃", "회원탈퇴"]
    ]
    
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "마이페이지"
        
        mypageView.tableView.dataSource = self
        mypageView.tableView.delegate = self
        
        // 테이블뷰 등록 및 설정
        mypageView.tableView.register(MypageViewCell.self, forCellReuseIdentifier: "MypageViewCell")
        tableviewSetup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.checkLoginStatus()
        
    }
    
    //MARK: - Methods
    //MARK: - func 로그인 관련 메서드
    // 로그인 상태 체크
    private func checkLoginStatus() {
        if let user  = Auth.auth().currentUser {
            // 로그인 상태라면
            print("사용자 uid: \(user.uid)")
            isLoggedIn = true
            loadUserData(uid: user.uid)
            mypageView.tableView.isHidden = false
        } else {
            // 비로그인 상태라면
            isLoggedIn = false
            
            print("로그인 없이 둘러보기 상태입니다.")
            self.tableViewHeaderSetUp(nickname: "로그인해주세요.   〉", email: "회원가입하고 씀씀이의 더 많은 정보를 이용해보세요.")
            mypageView.tableView.isHidden = true
            showLoginButton()
        }
    }
    
    // 비회원 접속 시 화면
    private func showLoginButton() {
        let label = UILabel()
        label.text = "로그인 후 이용 가능해요."
        label.textColor = .lightGray
        
        let loginButton = UIButton(type: .system)
        loginButton.setTitle("회원가입/로그인 하기", for: .normal)
        loginButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        loginButton.tintColor = .black
        loginButton.layer.borderColor = UIColor.systemGray5.cgColor
        loginButton.layer.borderWidth = 1
        loginButton.layer.cornerRadius = 10
        loginButton.addTarget(self, action: #selector(switchToLoginVC), for: .touchUpInside)
        
        [label, loginButton].forEach { view.addSubview($0)}
        
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(16)
            $0.width.equalTo(200)
            $0.height.equalTo(50)
            $0.centerX.equalToSuperview()
        }
    }
    
    // 로그인VC으로 화면전환
    @objc func switchToLoginVC() {
        let loginVC = LoginVC()
        let navController = UINavigationController(rootViewController: loginVC)
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        window.rootViewController = navController
        window.makeKeyAndVisible()
    }
    
    
    //MARK: - 테이블뷰 관련 메서드
    func tableviewSetup() {
        view.addSubview(mypageView.tableView)
        mypageView.tableView.backgroundColor = .white
        mypageView.tableView.frame = view.bounds // 부모 뷰의 크기에 맞게 조정
        mypageView.tableView.separatorStyle = .none // 테이블뷰 구분선 없애기
    }
    
    
    //MARK: - 테이블뷰 헤더 관련 설정
    private func tableViewHeaderSetUp(nickname: String, email: String) {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 130))
        
        header.backgroundColor = .white
        
        // 닉네임
        let nicknameLabel: UILabel = {
            let label = UILabel(frame: header.bounds)
            label.text = "\(nickname) 님"
            label.font = .boldSystemFont(ofSize: 24)
            return label
        }()
        
        // 이메일
        let emailabel: UILabel = {
            let label = UILabel(frame: header.bounds)
            label.font = .systemFont(ofSize: 18)
            label.textColor = .lightGray
            label.text = email
            return label
        }()
        
        [nicknameLabel, emailabel].forEach {header.addSubview($0)}
        
        // 헤더에 탭 제스처 -> 헤더 부분 클릭 시 페이지 이동 등에 쓰일 예정
        //        let headerTapGesture = UITapGestureRecognizer(target: self, action: #selector(headerTapped))
        //        header.addGestureRecognizer(headerTapGesture)
        
        // 닉네임 오토레이아웃
        nicknameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(30)
            $0.top.equalToSuperview().inset(28)
        }
        
        // 이메일 오토레이아웃
        emailabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(30)
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(12)
        }
        
        mypageView.tableView.tableHeaderView = header
    }
    
    
    //MARK: - 테이블뷰 헤더 - 파이어베이스 사용자 회원가입 정보 읽기
    func loadUserData(uid: String) {
        FirebaseFirestoreManager.shared.fetchUserData(uid: uid) { result in
            switch result {
            case .success(let data):
                if let nickname = data["nickname"] as? String,
                   let email = data["email"] as? String {
                    self.tableViewHeaderSetUp(nickname: nickname, email: email)
                } else {
                    print("닉네임을 찾을 수 없습니다.")
                }
            case .failure(let error):
                self.showAlert(message: "데이터를 가져오는 도중 오류 발생: \(error.localizedDescription)", AlertTitle: "에러발생", buttonClickTitle: "확인")
            }
        }
    }
    
    // 개인정보 처리방침 노션 url 연결
    private func privacyPolicyUrl () {
        guard let url = URL(string: "https://valley-porch-b6d.notion.site/ce887a60fc15484f82f92194a3a44d2d") else {return}
        let safariVC = SFSafariViewController(url: url)
        self.present(safariVC, animated: true, completion: nil)
    }
    
    
    //MARK: - @objc 로그아웃
    @objc func logOutCellTapped() {
        do {
            if user != nil {
                try FirebaseAuth.Auth.auth().signOut()
                print("로그아웃하고 페이지 전환")
                
                showSyncAlert(message: "로그아웃되었습니다.", AlertTitle: "로그아웃", buttonClickTitle: "확인", method: switchToLoginVC)
            } else {
                switchToLoginVC()
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    //MARK: - @objc 회원탈퇴
    @objc func deleteUserButtonTapped(email:String, password: String) {
        
        FirebaseAuthManager.shared.deleteUser(email: email, password: password) { success, error in
            if success {
                print("회원탈퇴 완료")
                self.showSyncAlert(message: "회원탈퇴되었습니다.", AlertTitle: "회원탈퇴 성공", buttonClickTitle: "확인", method: self.switchToLoginVC)
            } else if let error = error {
                print("회원탈퇴 실패: \(error.localizedDescription)")
                self.showAlert(message: "\(error)", AlertTitle: "오류 발생", buttonClickTitle: "확인 ")
            }
        }
    }
    
    // 알림 토글 스위치 설정
    @objc func toggleSwitchChanged(_ sender: UISwitch) {
        let isEnabled = sender.isOn
        
        if isEnabled {
            // 알림 활성화
//            NotificationManager.shared.test()
            NotificationManager.shared.firstDayOfMonthNotification()
            NotificationManager.shared.lastDayOfMonthNotification()
            print("알림이 활성화되었습니다.\(isEnabled)")
        } else {
            // 알림 비활성화
            NotificationManager.shared.cancelAllNotifications()
            print("알림이 비활성화되었습니다.\(isEnabled)")
        }
        
        if user != nil {
            userData.notificationsEnabled = isEnabled
            guard let uid = user?.uid else {return}
            
            FirebaseFirestoreManager.shared.updateUserField(uid: uid, field: "notificationsEnabled", value: isEnabled) { updateResult in
                switch updateResult {
                case .success:
                    print("사용자 정보 저장 성공")
                case .failure(let error):
                    print("사용자 정보 저장 실패: \(error.localizedDescription)")
                }
            }
        }
        
    }
}


//MARK: - 마이페이지 테이블뷰 델리게이트
// 행의 높이, 선택 시의 동작, 헤더와 푸터의 커스터마이징 등
extension MypageVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if user == nil {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        } else {
            switch (indexPath.section, indexPath.row) {
            case (0, 0):
                print("회원정보 수정 페이지로 이동")
                let editUserInfo = EditUserInfoVC()
                navigationController?.pushViewController(editUserInfo, animated: true)
            case (0, 1):
                print("비밀번호 재설정 클릭")
                let resetPasswordVC = ResetPasswordVC()
                navigationController?.pushViewController(resetPasswordVC, animated: true)
            case (1, 0):
                print("알림 설정")
            case (2, 0):
                print("개인정보처리방침으로 이동")
                privacyPolicyUrl()
            case (3, 0):
                print("앱버전")
            case (3, 1):
                print("로그아웃 클릭")
                logOutCellTapped()
            case (3, 2):
                print("회원탈퇴")
                let reauthenticationVC = ReauthenticationVC()
                navigationController?.pushViewController(reauthenticationVC, animated: true)
            default:
                break
            }
        }
    }
    
    // 특정 셀의 높이를 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    // 섹션 헤더 높이 설정
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 80.0 : 50.0
        //        return 50.0
    }
    
    // 섹션 헤더뷰 설정
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white
        
        // 섹션 헤더 상단에 간격 추가 (첫 번째 섹션에만 적용)
        if section == 0 {
            let topSpacingView = UIView()
            topSpacingView.backgroundColor = .systemGray6
            headerView.addSubview(topSpacingView)
            
            topSpacingView.snp.makeConstraints {
                $0.top.leading.trailing.equalToSuperview()
                $0.height.equalTo(20)
            }
        }
        
        // 각 섹션 별 섹션 타이틀의 폰트 및 위치 설정
        let titleLabel = UILabel()
        titleLabel.text = headers[section]
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = .darkGray
        
        headerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(10)
        }
        return headerView
    }
    
    // 섹션 헤더의 폰트와 폰트 크기, 폰트 색상 설정
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.font = UIFont.systemFont(ofSize: 16) // 폰트 크기와 스타일 변경
            header.textLabel?.textColor = .darkGray
        }
    }
    
    // 섹션 푸터 높이 설정
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20.0
    }
    
}

//MARK: - 마이페이지 테이블뷰 데이터소스
extension MypageVC: UITableViewDataSource {
    
    // 테이블뷰가 몇 개의 섹션을 가질지를 반환
    func numberOfSections(in tableView: UITableView) -> Int {
        return headers.count
    }
    
    // 각 섹션에 몇 개의 행이 있을지를 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    // 특정 섹션의 특정 행에 표시될 셀을 구성하고 반환
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MypageViewCell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row]
        cell.textLabel?.font = .systemFont(ofSize: 18)
        
        // 꺽쇠 표시 추가
        cell.accessoryType = .disclosureIndicator
        
        // 셀의 선택 효과를 없애기
        cell.selectionStyle = .none
        
        // "알림 설정" 셀에만 UISwitch 추가
        if indexPath.section == 1 && indexPath.row == 0 {
            let toggleSwitch = UISwitch()
            toggleSwitch.addTarget(self, action: #selector(toggleSwitchChanged(_:)), for: .valueChanged)
            
            FirebaseFirestoreManager.shared.fetchUserField(uid: user?.uid ?? "", field: "notificationsEnabled") { result in
                switch result {
                case .success(let value):
                    if let notificationsEnabled = value as? Bool {
                        DispatchQueue.main.async {
                            toggleSwitch.isOn = notificationsEnabled
                        }
                    }
                case .failure(let error):
                    print("에러 발생: \(error.localizedDescription)")
                }
            }
            
            cell.accessoryView = toggleSwitch
        }
        
        // "앱 버전" 셀에만 텍스트 추가
        if indexPath.section == 3 && indexPath.row == 0 {
            let label = UILabel()
            label.text = "1.3.3"
            label.textColor = .lightGray
            label.sizeToFit()
            cell.accessoryView = label
        }
        return cell
    }
    
}


