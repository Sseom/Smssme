//
//  Mypage.swift
//  Smssme
//
//  Created by ahnzihyeon on 8/29/24.
//

import UIKit

class Mypage: UIView {
    
    // 로그아웃 버튼
    private let logoutButton = BaseButton().createButton(text: "로그아웃", color: .systemBlue, textColor: .white)
    
    // 회원탈퇴 버튼
    private let deleteUserButton = BaseButton().createButton(text: "회원탈퇴", color: .systemGray4, textColor: .systemBlue)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureUI() {
        [logoutButton, deleteUserButton].forEach { self.addSubview($0) }
    }
    
    private func setupLayout() {
        logoutButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        deleteUserButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(logoutButton.snp.bottom).inset(18)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
        }
    }
}
