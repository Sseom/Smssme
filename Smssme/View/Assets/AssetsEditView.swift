//
//  AssetsEditView.swift
//  Smssme
//
//  Created by 전성진 on 8/30/24.
//

import SnapKit
import UIKit

class AssetsEditView: UIView {
    //MARK: - Factory Component Properties
    private let categoryLabel = ContentLabel().createLabel(with: "카테고리", color: .black)
    private let titleLabel = ContentLabel().createLabel(with: "항목", color: .black)
    private let amountLabel = ContentLabel().createLabel(with: "금액", color: .black)
    private let noteLabel = ContentLabel().createLabel(with: "메모", color: .black)
    
    let categoryTextField = BaseTextField().createTextField(placeholder: "카테고리", textColor: .black)
    let titleTextField = BaseTextField().createTextField(placeholder: "항목", textColor: .black)
    let amountTextField = BaseTextField().createTextField(placeholder: "금액", textColor: .black)
    let noteTextField = BaseTextField().createTextField(placeholder: "메모", textColor: .black)
    
    let cancelButton = BaseButton().createButton(text: "취소", color: .lightGray, textColor: .white)
    let saveButton = BaseButton().createButton(text: "저장", color: .systemBlue, textColor: .white)
    
    //MARK: - Component Properties
    private let contentsView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let contentsVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
//        stackView.backgroundColor = .darkGray
//        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 50, right: 10)
//        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    let deleteButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        barButton.image = UIImage(systemName: "trash")
        return barButton
    }()
        
    // MARK: - View Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    // MARK: - Private Method
    private func setHorizontalStackView(components: [UIView], distrbution: UIStackView.Distribution) {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = distrbution
        components.forEach {
            stackView.addArrangedSubview($0)
        }
        
        contentsVerticalStackView.addArrangedSubview(stackView)
    }
    
    private func setupUI() {
        [contentsView].forEach {
            self.addSubview($0)
        }
        
        [contentsVerticalStackView].forEach {
            contentsView.addSubview($0)
        }
        
        // horizontalStackView 세팅
        setHorizontalStackView(components: [categoryLabel, categoryTextField], distrbution: .fill)
        setHorizontalStackView(components: [titleLabel, titleTextField], distrbution: .fill)
        setHorizontalStackView(components: [amountLabel, amountTextField], distrbution: .fill)
        setHorizontalStackView(components: [noteLabel, noteTextField], distrbution: .fill)
        setHorizontalStackView(components: [cancelButton, saveButton], distrbution: .fillEqually)
        
        contentsView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        contentsVerticalStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(30)
        }
        
        // label 길이 정렬
        [categoryLabel,
         amountLabel,
         titleLabel].forEach {
            $0.snp.makeConstraints {
                $0.width.equalTo(70)
                $0.height.equalTo(34)
            }
        }
        
        noteLabel.snp.makeConstraints {
            $0.width.equalTo(70)
        }
        
        cancelButton.snp.makeConstraints {
            $0.height.equalTo(40)
        }
    }
    
    //MARK: - Objc
}
