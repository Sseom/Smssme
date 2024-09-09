//
//  PasswordView.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/8/24.
//

import UIKit

class PasswordView: UIView {
    
    private let commonHeight = 50
    
    //상단 제목 라벨
    private var titleLabel = LargeTitleLabel().createLabel(with: "비밀번호 입력 페이지가 될수도?", color: UIColor.black)
    
    //다음 버튼
    var nextButton = BaseButton().createButton(text: "다음", color: UIColor.systemBlue, textColor: UIColor.white)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        setupLayout()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - func
    private func configureUI() {
        self.backgroundColor = .white
        
        [titleLabel, nextButton].forEach {self.addSubview($0)}
    }
    
    private func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(24)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(commonHeight)
        }
    }
}
