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
    
    private let commonHeight = 50
    
    //MARK: - 성별 선택
    let genderTitleLabel = SmallTitleLabel().createLabel(with: "성별", color: .black)
    
    // 남성 체크박스
    var maleCheckBox: UIButton = {
        let button = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .semibold, scale: .large)
        button.setBackgroundImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        button.setBackgroundImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal) //자신의 크기 유지
        button.tag = GenderTags.male.rawValue
        return button
    }()
    let maleCheckBoxLabel: UILabel = {
        let label = UILabel()
        label.text = "남성"
        label.font = .systemFont(ofSize: 18)
        label.textColor = .darkGray
        return label
    }()
    
    // 여성 체크박스
    var femaleCheckBox: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        button.setBackgroundImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
//        button.setContentHuggingPriority(.defaultHigh, for: .horizontal) //자신의 크기 유지
        button.tag = GenderTags.female.rawValue
        return button
    }()
    let femaleLabel: UILabel = {
        let label = UILabel()
        label.text = "여성"
        label.font = .systemFont(ofSize: 18)
        label.textColor = .darkGray
        return label
    }()

    
    // 선택안함 체크박스
    var noneCheckBox: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        button.setBackgroundImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        button.tag = GenderTags.none.rawValue
        return button
    }()
    let noneLabel: UILabel = {
        let label = UILabel()
        label.text = "선택안함"
        label.font = .systemFont(ofSize: 18)
        label.textColor = .darkGray
        return label
    }()

    
    //MARK: - 소득 구간 선택
    private let incomeTitleLabel = SmallTitleLabel().createLabel(with: "소득 구간", color: .black)
    
    var incomeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "소득 구간을 선택하세요."
        textField.textColor = .black
        textField.backgroundColor = .clear
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.systemGray5.cgColor
        textField.layer.cornerRadius = 8
        textField.tintColor = .clear
        textField.addLeftPadding()
        textField.tag = 1
        return textField
    }()
    
    
    //MARK: - 지역 선택
    private let locationTitleLabel = SmallTitleLabel().createLabel(with: "지역", color: .black)
    
    var locationTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "지역을 선택하세요."
        textField.textColor = .black
        textField.backgroundColor = .clear
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.systemGray5.cgColor
        textField.layer.cornerRadius = 8
        textField.tintColor = .clear
        textField.addLeftPadding()
        textField.tag = 2
        return textField
    }()
    
    let agreementLabel: UILabel = {
        let label = UILabel()
        label.text = "회원가입 버튼을 누르면, 개인정보취급방침 및\n이용약관을 읽고 동의 한 것으로 간주합니다."
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    //MARK: - 다음 버튼
    var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원 가입", for: .normal)
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
        
        [ //titleLabel,
         genderTitleLabel,
         maleCheckBox,
         maleCheckBoxLabel,
         femaleCheckBox,
         femaleLabel,
         noneCheckBox,
         noneLabel,
         incomeTitleLabel,
         incomeTextField,
         locationTitleLabel,
         locationTextField,
         agreementLabel,
         nextButton].forEach {self.addSubview($0)}
    }

    private func loadGender(gender: String?) {
        if gender == "male" {
            self.maleCheckBox.isSelected = true
        } else if gender == "female" {
            self.femaleCheckBox.isSelected = true
        } else {
            self.noneCheckBox.isSelected = true
        }
    }
    
    //MARK: - @objc
    // 빈 화면 터치 시 키보드 내려감
    @objc func touch() {
        self.endEditing(true)
    }
    
    private func setupLayout() {
   
        genderTitleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(30)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
        }
        
        maleCheckBox.snp.makeConstraints {
            $0.top.equalTo(genderTitleLabel.snp.bottom).offset(14)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(30)
            $0.height.width.equalTo(28)
        }
        maleCheckBoxLabel.snp.makeConstraints {
            $0.top.equalTo(genderTitleLabel.snp.bottom).offset(14)
            $0.leading.equalTo(maleCheckBox.snp.trailing).offset(5)
            $0.centerY.equalTo(maleCheckBox)
        }
        
        femaleCheckBox.snp.makeConstraints {
            $0.top.equalTo(genderTitleLabel.snp.bottom).offset(14)
            $0.leading.equalTo(maleCheckBoxLabel.snp.trailing).offset(24)
            $0.height.width.equalTo(28)
        }
        femaleLabel.snp.makeConstraints {
            $0.top.equalTo(genderTitleLabel.snp.bottom).offset(14)
            $0.leading.equalTo(femaleCheckBox.snp.trailing).offset(5)
            $0.centerY.equalTo(maleCheckBox)
        }
        
        noneCheckBox.snp.makeConstraints {
            $0.top.equalTo(genderTitleLabel.snp.bottom).offset(14)
            $0.leading.equalTo(femaleLabel.snp.trailing).offset(24)
            $0.height.width.equalTo(28)
        }
        noneLabel.snp.makeConstraints {
            $0.top.equalTo(genderTitleLabel.snp.bottom).offset(14)
            $0.leading.equalTo(noneCheckBox.snp.trailing).offset(5)
            $0.centerY.equalTo(maleCheckBox)
        }
            
        incomeTitleLabel.snp.makeConstraints {
            $0.top.equalTo(noneLabel
                .snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(commonHeight)
        }
        incomeTextField.snp.makeConstraints {
            $0.top.equalTo(incomeTitleLabel.snp.bottom)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(commonHeight)
        }
        
        locationTitleLabel.snp.makeConstraints {
            $0.top.equalTo(incomeTextField.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(commonHeight)
        }
        locationTextField.snp.makeConstraints {
            $0.top.equalTo(locationTitleLabel.snp.bottom)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(commonHeight)
        }
        
        agreementLabel.snp.makeConstraints {
            $0.top.equalTo(locationTextField.snp.bottom).offset(25)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
        }
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(30)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(240)
            $0.height.equalTo(commonHeight)
        }
    }
}

