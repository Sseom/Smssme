//
//  UIButtonFactory.swift
//  Smssme
//
//  Created by 임혜정 on 9/25/24.
//

import UIKit

// MARK: - 빌더 패턴으로 전환중 UI Component #button

//extension UIColor { // 텍스트 색상 정의
//    static let labelBlack = UIColor(hex: "#060b11")
//    static let bodyGray = UIColor(hex: "#5d6285")
//    static let disableGray = UIColor(hex: "#80828f")
//}

class ButtonBuilder {
    private var title: String = ""
    private var titleColor: UIColor = .black
    private var fillColor: UIColor = .black
    private var font: UIFont = .systemFont(ofSize: 16)
    private var align: NSTextAlignment = .center
    private var letterSpacing: CGFloat?
    private var borderColor: UIColor = .clear
    private var borderWidth: CGFloat = 0

    func setBorderColor(_ borderColor: UIColor) -> ButtonBuilder {
        self.borderColor = borderColor
        return self
    }
    
    func setBorderWidth(_ borderWidth: CGFloat) -> ButtonBuilder {
        self.borderWidth = borderWidth
        return self
    }
    
    func setTitle(_ title: String) -> ButtonBuilder {
        self.title = title
        return self
    }
    
    func setTitleColor(_ titleColor: UIColor) -> ButtonBuilder {
        self.titleColor = titleColor
        return self
    }
    
    func setFillColor(_ fillColor: UIColor) -> ButtonBuilder {
        self.fillColor = fillColor
        return self
    }
    
    func setFont(_ font: UIFont) -> ButtonBuilder {
        self.font = font
        return self
    }
    
    func setAlign(_ align: NSTextAlignment) -> ButtonBuilder {
        self.align = align
        return self
    }
    
    func setLetterSpacing(_ spacing: CGFloat) -> ButtonBuilder {
        self.letterSpacing = spacing
        return self
    }
    
    func build() -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.backgroundColor = fillColor
        button.titleLabel?.font = font
        button.layer.borderColor = borderColor.cgColor
        button.layer.borderWidth = borderWidth
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        
        return button
    }
}

extension ButtonBuilder { // 텍스트 사이즈, 자간 설정
    static let titleSize: CGFloat = 24
    static let titleSpacing: CGFloat = titleSize * -0.02
    
    static let bodySize: CGFloat = 16
    static let bodySpacing: CGFloat = bodySize * -0.04
    
    static let captionSize: CGFloat = 12
    static let captionSpacing: CGFloat = captionSize * 0
}

// 생성기
class ButtonFactory {
    static func clearButton() -> ButtonBuilder {
        return ButtonBuilder()
            .setFillColor(.white)
            .setBorderColor(.black)
            .setBorderWidth(1)
    }
    
    static func fillButton() -> ButtonBuilder {
        return ButtonBuilder()
    }
}

