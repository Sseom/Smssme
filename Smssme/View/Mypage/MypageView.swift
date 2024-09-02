//
//  Mypage.swift
//  Smssme
//
//  Created by ahnzihyeon on 8/29/24.
//

import UIKit
import FirebaseAuth

class MypageView: UIView {
        
    // 마이페이지 라벨
    let myPageTitleLabel = LargeTitleLabel().createLabel(with: "마이페이지", color: .black)
    
    // 유저 아이디(이메일) 라벨
    let userEmailLabel = BaseLabelFactory().createLabel(with: "", color: .black)
    
    
    // 로그아웃 버튼
    let logoutButton = BaseButton().createButton(text: "로그아웃", color: .systemBlue, textColor: .white)
    
    // 회원탈퇴 버튼
    let deleteUserButton = BaseButton().createButton(text: "회원탈퇴", color: .systemGray4, textColor: .systemBlue)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureUI() {
        [myPageTitleLabel,
         userEmailLabel,
         logoutButton,
         deleteUserButton].forEach { self.addSubview($0) }
    }
    
    private func setupLayout() {
        myPageTitleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(18)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        userEmailLabel.snp.makeConstraints {
            $0.top.equalTo(myPageTitleLabel.snp.bottom).offset(30)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        logoutButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(userEmailLabel.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(48)
        }
        
        deleteUserButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(logoutButton.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(48)
        }
    }
}
