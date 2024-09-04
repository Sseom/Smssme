//
//  TestTableViewController.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/4/24.
//

import SnapKit
import UIKit

class TestTableViewController: UIViewController {
    
    
    // 테이블뷰
    lazy var tableView = UITableView(frame: .zero, style: .grouped)
    
    // section headers
    private let headers: [String] = ["회원정보", "설정", "서비스 안내", "계정"]
    
    // 각 cell에 들어갈 정보
    private let data = [
        ["내 정보 관리"],
        ["알림 설정"],
        ["개인정보처리 방침"],
        ["로그아웃", "회원탈퇴"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .white
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        // 테이블뷰 등록 및 설정
        tableView.register(TestTableViewCell.self, forCellReuseIdentifier: "TestTableViewCell")
        

        
        view.addSubview(tableView)
        tableView.frame = view.bounds // 테이블뷰를 부모 뷰의 크기에 맞게 조정해주어, 화면 전체에 테이블뷰가 잘 보이도록 설정
        
        // 테이블뷰 구분선 없애기
        tableView.separatorStyle = .none
        
        tableViewHeaderSetUp()
    }
    
    // 헤더 관련 설정
    private func tableViewHeaderSetUp() {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 150))
        
        header.backgroundColor = .systemPink
        
        var nicknameLabel: UILabel = {
            let label = UILabel(frame: header.bounds)
            label.text = "춤추는 닭강정님"
            label.font = .boldSystemFont(ofSize: 24)
            return label
        }()
        
        let emailabel: UILabel = {
            let label = UILabel(frame: header.bounds)
            label.font = .systemFont(ofSize: 18)
            label.textColor = .lightGray
            label.text = "dkswlgus0314@naver.com"
            return label
        }()
        
        [nicknameLabel, emailabel].forEach { header.addSubview($0)}
        [header].forEach {view.addSubview($0)}
        
        tableView.tableHeaderView = header
        
        // 오토레이아웃
        nicknameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(30)
            $0.top.equalToSuperview().inset(28)
        }
        
        emailabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(30)
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(12)
        }
        
        
    }
    
    
    
}


//MARK: - 마이페이지 테이블뷰 델리게이트
// 행의 높이, 선택 시의 동작, 헤더와 푸터의 커스터마이징 등
extension TestTableViewController: UITableViewDelegate {
    
    // 각 섹션의 헤더 타이틀 정의
    //    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        return headers[section]
    //    }
    
    // 테이블뷰의 특정 셀을 선택했을 때 호출됨. 이 메서드에서 선택된 셀에 따라 동작을 정의할 수 있음
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("섹션 \(indexPath.section), 행 \(indexPath.row) 선택됨")
        // 테스터
        if indexPath.section == 3 && indexPath.row == 0 {
            print("셀이 선택되었을 때, 계정 - 로그아웃 일 것으로 예상됩니다만?  ")
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
            topSpacingView.backgroundColor = .systemGray5
            headerView.addSubview(topSpacingView)
            
            topSpacingView.snp.makeConstraints {
                $0.top.leading.trailing.equalToSuperview()
                $0.height.equalTo(20) // 원하는 간격 크기
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
        
        let separatorLine = UIView()
        separatorLine.backgroundColor = .systemGray4
        footerView.addSubview(separatorLine)
        
        separatorLine.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.top.equalToSuperview()
            $0.height.equalTo(0.5) // 구분선의 높이
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
//테이블뷰에 표시될 데이터를 관리
extension TestTableViewController: UITableViewDataSource {
    
    // 테이블뷰가 몇 개의 섹션을 가질지를 반환
    func numberOfSections(in tableView: UITableView) -> Int {
        return headers.count
    }
    
    // 각 섹션에 몇 개의 행이 있을지를 반환
    // -> 첫 번째 섹션(회원정보)에는 한 개의 행이 있고, 네 번째 섹션(계정)에는 두 개의 행이 있으므로 섹션 인덱스에 따라 다른 값을 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data[section].count
    }
    
    // 특정 섹션의 특정 행에 표시될 셀을 구성하고 반환
    // indexPath.section과 indexPath.row를 사용해 해당 위치의 데이터를 찾아 셀에 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestTableViewCell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row]
        
        cell.textLabel?.font = .boldSystemFont(ofSize: 18)
        
        // 꺽쇠 표시 추가
        cell.accessoryType = .disclosureIndicator
        
        // 셀의 선택 효과를 없애기
        cell.selectionStyle = .none
        
        // "알림 설정" 셀에만 UISwitch 추가
        if indexPath.section == 1 && indexPath.row == 0 {
            let toggleSwitch = UISwitch()
            toggleSwitch.isOn = true // 기본적으로 스위치가 켜진 상태로 설정
//            toggleSwitch.addTarget(self, action: #selector(didChangeSwitch(_:)), for: .valueChanged)
            
            cell.accessoryView = toggleSwitch
        }
        
        return cell
    }
    
    
}

