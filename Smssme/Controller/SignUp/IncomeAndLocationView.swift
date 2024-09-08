//
//  ncomeAndLocationView.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/8/24.
//

import UIKit

// 성별 선택 tag
enum GenderTags: Int {
    case male = 1
    case female = 2
    case none = 3
}

class IncomeAndLocationView: UIView {
    
    // 성별 선택
    // 성별 라벨
    let genderTitleLabel = SmallTitleLabel().createLabel(with: "성별", color: .darkGray)
    
    // 남성 체크박스
    var maleCheckBox: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
        button.setBackgroundImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        button.tag = GenderTags.male.rawValue
        return button
    }()
    
    let maleCheckBoxLabel: UILabel = {
        let label = UILabel()
        label.text = "남성"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        return label
    }()
    
    let maleCheckBoxStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()
    
    // 여성 체크박스
    var femaleCheckBox: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
        button.setBackgroundImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        button.tag = GenderTags.female.rawValue
        return button
    }()
    
    let femaleLabel: UILabel = {
        let label = UILabel()
        label.text = "여성"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        return label
    }()
    
    let femaleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    // 선택안함 체크박스
    var noneCheckBox: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
        button.setBackgroundImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        button.tag = GenderTags.none.rawValue
        return button
    }()
    
    let noneLabel: UILabel = {
        let label = UILabel()
        label.text = "선택안함"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        return label
    }()
    
    let noneStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    // 남성, 여성, 선택안함 담는 가로스택뷰
    let genderOptionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // 성별 라벨, 성별 체크박스 담는 세로 스택뷰
    let genderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    
    
    //소득 구간 선택
    var incomeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "소득 구간을 선택하세요."
        textField.textColor = UIColor.lightGray
        textField.borderStyle = .roundedRect
        textField.tintColor = .clear
        textField.layer.cornerRadius = 5
        textField.tag = 1
        return textField
    }()
    
    //지역 선택
    var locationTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "지역"
        textField.textColor = UIColor.lightGray
        textField.borderStyle = .roundedRect
        textField.tintColor = .clear
        textField.layer.cornerRadius = 5
        textField.tag = 2
        return textField
    }()
    
    //다음 버튼
    var nextButton = BaseButton().createButton(text: "다음", color: UIColor.systemBlue, textColor: UIColor.white)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

