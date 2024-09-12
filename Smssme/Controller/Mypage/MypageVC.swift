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
    
    var isLoggedIn: Bool = false
    let db = Firestore.firestore()
    
    
    // section headers
    private let headers: [String] = ["회원정보", "설정", "서비스 안내", "계정"]
    
    // 각 cell에 들어갈 정보
    private let data = [
        ["내 정보 수정"],
        ["알림 설정"],
        ["개인정보처리 방침"],
        ["로그아웃", "회원탈퇴"]
    ]
    
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mypageView.tableView.dataSource = self
        mypageView.tableView.delegate = self
        
        // 테이블뷰 등록 및 설정
        mypageView.tableView.register(MypageViewCell.self, forCellReuseIdentifier: "MypageViewCell")
        
        tableviewSetup()
        
        setupAddtarget()
        checkLoginStatus()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.checkLoginStatus()
        
        // 로그인 상태에 따른 테이블뷰 표시 여부
        if isLoggedIn {
            mypageView.tableView.isHidden = false
        } else {
            mypageView.tableView.isHidden = true
            addLoginButton()
        }
    }
    
    
    // 로그인 버튼 추가
    private func addLoginButton() {
        let label = UILabel()
        label.text = "로그인 후 이용 가능해요."
        label.textColor = .lightGray
        
        let loginButton = UIButton(type: .system)
        loginButton.setTitle("로그인 하러 가기", for: .normal)
        loginButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        loginButton.tintColor = .black
        loginButton.layer.borderColor = UIColor.systemGray5.cgColor
        loginButton.layer.borderWidth = 1
        loginButton.layer.cornerRadius = 10
        loginButton.addTarget(self, action: #selector(handleLoginButton), for: .touchUpInside)
        
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

    // 로그인 버튼 클릭 시 로그인 화면으로 이동
    @objc private func handleLoginButton() {
        MypageVC().switchToLoginVC()
    }
    
    //MARK: - 테이블뷰 관련 메서드
    func tableviewSetup() {
        view.addSubview(mypageView.tableView)
        
        mypageView.tableView.backgroundColor = .white
        
        // 테이블뷰를 부모 뷰의 크기에 맞게 조정해주어, 화면 전체에 테이블뷰가 잘 보이도록 설정
        mypageView.tableView.frame = view.bounds
        
        // 테이블뷰 구분선 없애기
        mypageView.tableView.separatorStyle = .none
    }
    
    
    // 헤더 관련 설정
    private func tableViewHeaderSetUp(nickname: String, email: String) {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 130))
        
        header.backgroundColor = .white
        
        // 닉네임
        var nicknameLabel: UILabel = {
            let label = UILabel(frame: header.bounds)
            label.text = nickname
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
        
        // 비회원 로그인 시 헤더에 탭 제스처 추가
        let headerTapGesture = UITapGestureRecognizer(target: self, action: #selector(headerTapped))
        header.addGestureRecognizer(headerTapGesture)
        
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
    
    
    //MARK: - func
    private func setupAddtarget() {
        // 로그아웃 버튼 이벤트
        mypageView.logoutButton.addTarget(self, action: #selector(logOutButtonTapped), for: .touchUpInside)
        
        // 회원탈퇴 버튼 이벤트
        mypageView.deleteUserButton.addTarget(self, action: #selector(deleteUserButtonTapped), for: .touchUpInside)
    }
    
    // 로그인VC으로 화면전환
    func switchToLoginVC() {
        let loginVC = LoginVC()
        let navController = UINavigationController(rootViewController: loginVC)
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        window.rootViewController = navController
        window.makeKeyAndVisible()
    }
    
    // 개인정보 처리방침 노션 url 연결
    private func privacyPolicyUrl () {
        guard let url = URL(string: "https://valley-porch-b6d.notion.site/ce887a60fc15484f82f92194a3a44d2d") else {return}
        let safariVC = SFSafariViewController(url: url)
        self.present(safariVC, animated: true, completion: nil)
    }
    
    
    // 현재 로그인한 사용자 아이디(이메일 정보)
    private func checkLoginStatus() {
        if let user  = Auth.auth().currentUser {
            // 로그인 상태라면
            print("사용자 uid: \(user.uid)")
            isLoggedIn = true
            loadUserData(uid: user.uid)
            
        } else {
            // 비로그인 상태라면
            isLoggedIn = false
            
            print("로그인 없이 둘러보기 상태입니다.")
            self.tableViewHeaderSetUp(nickname: "로그인해주세요. ", email: "슴씀이의 더 많은 정보를 이용하러 가기!")
        }
    }
    
    
    //MARK: - loadUserData: 파이어베이스 사용자 회원가입 정보 읽기
    func loadUserData(uid: String) {
        
        db.collection("users").document(uid).getDocument { (snapshot, error) in
            if let error = error {
                print("Error fetching user data:\n \(error.localizedDescription)")
                return
            }
            guard let data = snapshot?.data() else {
                print("No data found")
                return
            }
            
            let nickname = data["nickname"] as? String ?? "닉네임을 설정해주세요"
            let email = Auth.auth().currentUser?.email ?? "이메일을 설정해주세요"
            self.tableViewHeaderSetUp(nickname: nickname, email: email)
        }
    }
    
    //MARK: - @objc 테이블뷰의 헤더 클릭 이벤트
    @objc
    private func headerTapped() {
        if Auth.auth().currentUser == nil {
            showSnycAlert(message: "로그인으로 이동합니다.", AlertTitle: "", buttonClickTitle: "확인", method: switchToLoginVC)
            return
        }
    }
    //MARK: - @objc 로그아웃
    @objc func logOutButtonTapped() {
        do {
            if Auth.auth().currentUser?.uid != nil {
                try FirebaseAuth.Auth.auth().signOut()
                print("로그아웃하고 페이지 전환")
                
                showSnycAlert(message: "로그아웃되었습니다.", AlertTitle: "로그아웃", buttonClickTitle: "확인", method: switchToLoginVC)
            } else {
                switchToLoginVC()
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    //MARK: - @objc 회원탈퇴
    @objc func deleteUserButtonTapped() {
        if let user = Auth.auth().currentUser {
            user.delete { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    self.showAlert(message: "\(error)", AlertTitle: "오류 발생", buttonClickTitle: "확인 ")
                } else {
                    print("회원탈퇴 완료")
                    self.showSnycAlert(message: "회원탈퇴되었습니다.", AlertTitle: "회원탈퇴 성공", buttonClickTitle: "확인", method: switchToLoginVC)
                }
            }
        } else {
            showAlert(message: "로그인 정보가 존재하지 않습니다", AlertTitle: "오류 발생", buttonClickTitle: "확인")
        }
        
    }
    
}



//MARK: - 마이페이지 테이블뷰 델리게이트
// 행의 높이, 선택 시의 동작, 헤더와 푸터의 커스터마이징 등
extension MypageVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("섹션 \(indexPath.section), 행 \(indexPath.row) 선택됨")
        
        if Auth.auth().currentUser == nil {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        } else {
            switch (indexPath.section, indexPath.row) {
            case (0, 0):
                print("회원정보 수정 페이지로 이동")
                let signUpVC = SignUpVC()
                navigationController?.pushViewController(signUpVC, animated: true)
            case (1, 0):
                print("알림 설정")
            case (2, 0):
                print("개인정보처리방침으로 이동")
                privacyPolicyUrl()
            case (3, 0):
                print("로그아웃 클릭")
                logOutButtonTapped()
            case (3, 1):
                print("회원탈퇴 클릭")
                deleteUserButtonTapped()
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
    
    // 섹션 푸터 높이 설정
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    // 섹션 푸터뷰 설정
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .white
        
        // 섹션 간 구분선 설정
        let separatorLine = UIView()
        separatorLine.backgroundColor = .systemGray4
        footerView.addSubview(separatorLine)
        
        separatorLine.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.top.equalToSuperview()
            $0.height.equalTo(1)
        }
        return footerView
    }
    
    // 섹션의 폰트와 폰트 크기, 폰트 색상 설정
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.font = UIFont.systemFont(ofSize: 16) // 폰트 크기와 스타일 변경
            header.textLabel?.textColor = .darkGray
        }
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
        cell.textLabel?.font = .boldSystemFont(ofSize: 18)
        
        // 꺽쇠 표시 추가
        cell.accessoryType = .disclosureIndicator
        
        // 셀의 선택 효과를 없애기
        cell.selectionStyle = .none
        
        // "알림 설정" 셀에만 UISwitch 추가
        if indexPath.section == 1 && indexPath.row == 0 {
            let toggleSwitch = UISwitch()
            toggleSwitch.isOn = true
            cell.accessoryView = toggleSwitch
        }
        return cell
    }
    
    
}


