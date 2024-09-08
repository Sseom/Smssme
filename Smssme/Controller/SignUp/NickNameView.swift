//
//  NickNameView.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/8/24.
//

import UIKit

class NickNameView: UIView {

    //닉네임
    var nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임(10자 이내)"
        textField.textColor = UIColor.lightGray
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5
        textField.clearButtonMode = .always
        return textField
    }()
    
    //생년월일
    let birthdayTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "생년월일 8자리 입력(예:  1900/01/31)"
        textField.textColor = UIColor.lightGray
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5
        textField.clearButtonMode = .always
        textField.keyboardType = UIKeyboardType.phonePad
        return textField
    }()
    
    //생년월일 데이트피커뷰
    var datePickerView = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let temp = dateFormatter.date(from: "2000-01-01")
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.date = temp ?? Date()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko-KR")
        return datePicker
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
