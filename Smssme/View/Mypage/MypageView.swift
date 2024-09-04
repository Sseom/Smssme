//
//  Mypage.swift
//  Smssme
//
//  Created by ahnzihyeon on 8/29/24.
//

import UIKit
import FirebaseAuth

class MypageView: UIView {
    
    // 테이블뷰
    lazy var tableView = UITableView(frame: .zero, style: .grouped)
    
    
    // 마이페이지 라벨
    var myPageTitleLabel = LargeTitleLabel().createLabel(with: "마이페이지", color: .black)
    
    // 닉네임 라벨
    var nicknameLabel = BaseLabelFactory().createLabel(with: "닉네임", color: .black)
    
    // 유저 아이디(이메일) 라벨
    var userEmailLabel = BaseLabelFactory().createLabel(with: "아이디", color: .black)
    
    // Section1 - 프로필 정보 담는 스택뷰
    
    // 생년월일 라벨
    var birthdayLabel = BaseLabelFactory().createLabel(with: "생년월일", color: .black)
    
    // 성별 라벨
    var genderLabel = BaseLabelFactory().createLabel(with: "성별", color: .black)
    
    // 소득 라벨
    var incomeLabel = BaseLabelFactory().createLabel(with: "소득", color: .black)
    
    // 지역 라벨
    var locationLabel = BaseLabelFactory().createLabel(with: "지역", color: .black)
    
    var userInfoStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 18
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // 로그아웃 버튼
    let logoutButton = BaseButton().createButton(text: "로그아웃", color: .systemBlue, textColor: .white)
    
    // 회원탈퇴 버튼
    let deleteUserButton = BaseButton().createButton(text: "회원탈퇴", color: .systemGray4, textColor: .systemBlue)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
//        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureUI() {
//        self.backgroundColor = .systemGray4
        
//        [userEmailLabel,
//         nicknameLabel,
//         birthdayLabel,
//         genderLabel,
//         incomeLabel,
//         locationLabel,
//         logoutButton,
//         deleteUserButton].forEach { userInfoStackView.addArrangedSubview($0) }
        
        [tableView].forEach { self.addSubview($0) }
    }
    
//    private func setupLayout() {
//        myPageTitleLabel.snp.makeConstraints {
//            $0.top.equalTo(safeAreaLayoutGuide).inset(18)
//            $0.leading.equalTo(safeAreaLayoutGuide).inset(30)
//            $0.height.equalTo(38)
//            $0.centerX.equalToSuperview()
//        }
//        
//        userInfoStackView.snp.makeConstraints {
//            $0.top.equalTo(myPageTitleLabel.snp.bottom).offset(24)
//            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
//        }
//        
//        logoutButton.snp.makeConstraints {
////            $0.centerX.equalToSuperview()
////            $0.top.equalTo(userEmailLabel.snp.bottom).offset(30)
////            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
//            $0.height.equalTo(48)
//        }
//        
//        deleteUserButton.snp.makeConstraints {
////            $0.centerX.equalToSuperview()
////            $0.top.equalTo(logoutButton.snp.bottom).offset(30)
////            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
//            $0.height.equalTo(48)
//        }
//    }
}
