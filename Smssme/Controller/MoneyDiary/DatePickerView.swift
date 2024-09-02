//
//  DatePickerView.swift
//  Smssme
//
//  Created by KimRin on 9/2/24.
//

import UIKit
import SnapKit

class DatePickerView: UIView {
    let pickerView = UIPickerView()
    let titleLabel = LargeTitleLabel().createLabel(with: "날짜선택", color: .black)
    let confirmButton = BaseButton().createButton(text: "이동", color: .black, textColor: .white)
        let years = Array(2000...Calendar.current.component(.year, from: Date()) + 10)
        let months = Array(1...12)

        override init(frame: CGRect) {
            super.init(frame: frame)
            setupPickerView()
            self.backgroundColor = .white
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func setupPickerView() {
            
            
            [pickerView,
             titleLabel,
             confirmButton
            ].forEach { self.addSubview($0) }
            titleLabel.snp.makeConstraints {
                $0.top.equalTo(self.snp.top).offset(20)
                $0.leading.equalTo(self.snp.leading).offset(20)
            }
            pickerView.snp.makeConstraints {
                $0.centerX.equalTo(self)
                $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            }
            
            confirmButton.snp.makeConstraints {
                $0.centerX.equalTo(self)
                $0.top.equalTo(pickerView.snp.bottom).offset(40)
                $0.horizontalEdges.equalTo(self).inset(20)
                $0.height.equalTo(50)
                
            }
            

        }



        
}
