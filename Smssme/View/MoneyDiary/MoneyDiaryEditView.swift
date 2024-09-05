//
//  MoneyDiaryEditView.swift
//  Smssme
//
//  Created by 전성진 on 8/30/24.
//

import SnapKit
import UIKit

class MoneyDiaryEditView: UIView {
    //MARK: - Factory Component Properties
    private let dateLabel = ContentLabel().createLabel(with: "수입일", color: .black)
    private let priceLabel = ContentLabel().createLabel(with: "수입금액", color: .black)
    private let titleLabel = ContentLabel().createLabel(with: "수입명", color: .black)
    private let categoryLabel = ContentLabel().createLabel(with: "카테고리", color: .black)
    private let noteLabel = ContentLabel().createLabel(with: "메모", color: .black)
    
    let priceTextField = BaseTextField().createTextField(placeholder: "금액", textColor: .black)
    let titleTextField = BaseTextField().createTextField(placeholder: "수입명", textColor: .black)
    let categoryTextField = BaseTextField().createTextField(placeholder: "카테고리", textColor: .black)
    //    let noteTextField = BaseTextField().createTextField(placeholder: "메모", textColor: .black)
    
    let cancelButton = BaseButton().createButton(text: "취소", color: .lightGray, textColor: .white)
    let saveButton = BaseButton().createButton(text: "저장", color: .systemBlue, textColor: .white)
    
    //MARK: - Component Properties
    lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["지출", "수입"])
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(viewChange(segment:)), for: .valueChanged)
        return segmentControl
    }()
    
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
    
    let noteTextField: UITextView = {
        let textView = UITextView()
        textView.text = "메모"
        textView.textColor = .systemGray4
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.borderColor = UIColor.systemGray5.cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 6.0
        return textView
    }()
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        
        return datePicker
    }()
    
    // MARK: - View Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        noteTextField.delegate = self
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
        [segmentControl, contentsView].forEach {
            self.addSubview($0)
        }
        
        [contentsVerticalStackView].forEach {
            contentsView.addSubview($0)
        }
        
        // horizontalStackView 세팅
        setHorizontalStackView(components: [dateLabel, datePicker], distrbution: .fill)
        setHorizontalStackView(components: [priceLabel, priceTextField], distrbution: .fill)
        setHorizontalStackView(components: [titleLabel, titleTextField], distrbution: .fill)
        setHorizontalStackView(components: [categoryLabel, categoryTextField], distrbution: .fill)
        setHorizontalStackView(components: [noteLabel, noteTextField], distrbution: .fill)
        setHorizontalStackView(components: [cancelButton, saveButton], distrbution: .fillEqually)
        
        segmentControl.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.left.right.equalTo(self.safeAreaLayoutGuide).inset(30)
        }
        
        contentsView.snp.makeConstraints {
            $0.top.equalTo(segmentControl.snp.bottom)
            $0.left.right.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
        contentsVerticalStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(30)
        }
        
        // label 길이 정렬
        [dateLabel,
         priceLabel,
         titleLabel,
         categoryLabel].forEach {
            $0.snp.makeConstraints {
                $0.width.equalTo(70)
                $0.height.equalTo(34)
            }
        }
        
        noteLabel.snp.makeConstraints {
            $0.width.equalTo(70)
        }
        
        datePicker.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        cancelButton.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        dateLabel.text = "지출일"
        priceLabel.text = "지출금액"
        titleLabel.text = "지출명"
        titleTextField.placeholder = "지출명"
    }
    
    //MARK: - Objc
    //FIXME: View가 바뀌는 이벤트라 View에 넣는게 맞지 않을까
    @objc func viewChange(segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            dateLabel.text = "지출일"
            priceLabel.text = "지출금액"
            titleLabel.text = "지출명"
            titleTextField.placeholder = "지출명"
        } else {
            dateLabel.text = "수입일"
            priceLabel.text = "수입금액"
            titleLabel.text = "수입명"
            titleTextField.placeholder = "수입명"
        }
    }
}

extension MoneyDiaryEditView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.systemGray4 {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "메모"
            textView.textColor = .systemGray4
        }
    }
}
