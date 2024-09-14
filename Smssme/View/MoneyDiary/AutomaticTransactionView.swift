//
//  AutomaticTransactionView.swift
//  Smssme
//
//  Created by KimRin on 9/12/24.
//

import UIKit
import SnapKit

class AutomaticTransactionView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "자동지출추가입력기능"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
     let inputTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 8
        textView.font = UIFont.systemFont(ofSize: 16)
        return textView
    }()
    
     let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("제출", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        self.backgroundColor = .white
        
        // Add subviews
        self.addSubview(titleLabel)
        self.addSubview(inputTextView)
        self.addSubview(submitButton)
        
        // Layout using SnapKit
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        inputTextView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(150)
        }
        
        submitButton.snp.makeConstraints {
            $0.top.equalTo(inputTextView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()

            $0.horizontalEdges.equalTo(inputTextView)
            $0.height.equalTo(50)
        }
    }

}
