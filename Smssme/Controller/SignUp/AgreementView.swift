//
//  AgreementView.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/8/24.
//

import UIKit

class AgreementView: UIView {
    private let commonHeight = 50
    
    //상단 제목 라벨
    private var titleLabel = LargeTitleLabel().createLabel(with: "서비스 가입을 위해 \n이용약관에 동의해주세요.", color: UIColor.black)
    
    
    //다음 버튼
    var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGray5
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.isEnabled = false
        return button
    }()
    
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
        
        // 스크롤뷰에서 빈 화면터치 시 키보드 내려감
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.touch))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        
        self.addGestureRecognizer(recognizer)
        
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
    
    //MARK: - @objc
    // 빈 화면 터치 시 키보드 내려감
    @objc func touch() {
        self.endEditing(true)
    }
    
}
