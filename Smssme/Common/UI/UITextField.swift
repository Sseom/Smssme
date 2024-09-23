//
//  UITextField.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/8/24.
//

import UIKit

// 사용법 : 텍스트필드.addLeftPadding()

extension UITextField {
    // 텍스트필드 사용 시 텍스트와 플레이스홀더의 왼쪽 여백을 주는 메서드입니다.
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: self.frame.height))
        
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    
    // 텍스트필드 사용 시 오른쪽에 이미지를 넣는 메서드입니다.
//    func setIcon(_ image: UIImage) {
//        let iconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 24, height: 24 ))
//        iconView.image = image
//
//        let iconContainerView: UIView = UIView(frame: CGRect(x: 0,y: 0,width: 30,height: self.frame.height))
//        iconContainerView.addSubview(iconView)
//
//        self.rightView = iconContainerView
//        self.rightViewMode = .always
//    }
}
