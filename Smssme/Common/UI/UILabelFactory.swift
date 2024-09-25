//
//  UILabelFactory.swift
//  Smssme
//
//  Created by 임혜정 on 9/24/24.
//

import UIKit

// MARK: - 빌더 패턴으로 전환중 UI Component #label

extension UIColor { // 텍스트 색상 정의
    static let labelBlack = UIColor(hex: "#060b11")
    static let bodyGray = UIColor(hex: "#5d6285")
    static let disableGray = UIColor(hex: "#80828f")
}

class LabelBuilder {
    private var text: String = ""
    private var color: UIColor = .black
    private var font: UIFont = .systemFont(ofSize: 16)
    private var align: NSTextAlignment = .left
    private var letterSpacing: CGFloat?

    func setText(_ text: String) -> LabelBuilder {
        self.text = text
        return self
    }
    
    func setColor(_ color: UIColor) -> LabelBuilder {
        self.color = color
        return self
    }
    
    func setFont(_ font: UIFont) -> LabelBuilder {
        self.font = font
        return self
    }
    
    func setAlign(_ align: NSTextAlignment) -> LabelBuilder {
        self.align = align
        return self
    }
    
    func setLetterSpacing(_ spacing: CGFloat) -> LabelBuilder {
        self.letterSpacing = spacing
        return self
    }
    
    func build() -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = color
        label.font = font
        label.textAlignment = align
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        
        if let spacing = letterSpacing {
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(.kern, value: spacing, range: NSRange(location: 0, length: text.count))
            label.attributedText = attributedString
        }
        
        return label
    }
}

extension LabelBuilder { // 텍스트 사이즈, 자간 설정
    static let titleSize: CGFloat = 24
    static let titleSpacing: CGFloat = titleSize * -0.02
    
    static let bodySize: CGFloat = 16
    static let bodySpacing: CGFloat = bodySize * -0.04
    
    static let captionSize: CGFloat = 12
    static let captionSpacing: CGFloat = captionSize * 0
}

// 생성기
class LabelFactory {
    static func titleLabel() -> LabelBuilder {
        return LabelBuilder()
            .setFont(.boldSystemFont(ofSize: LabelBuilder.titleSize))
            .setColor(.labelBlack)
            .setAlign(.left)
            .setLetterSpacing(LabelBuilder.titleSpacing)
    }
    
    static func bodyLabel() -> LabelBuilder {
        return LabelBuilder()
            .setFont(.systemFont(ofSize: LabelBuilder.bodySize))
            .setColor(.labelBlack)
            .setAlign(.left)
            .setLetterSpacing(LabelBuilder.bodySpacing)
    }
    
    static func captionLabel() -> LabelBuilder {
        return LabelBuilder()
            .setFont(.systemFont(ofSize: LabelBuilder.captionSize))
            .setColor(.labelBlack)
            .setAlign(.left)
            .setLetterSpacing(LabelBuilder.captionSpacing)
    }
}
