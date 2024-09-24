//
//  UIComponentFactory.swift
//  Smssme
//
//  Created by 임혜정 on 8/26/24.
//

import UIKit

// MARK: - 앱 전체에서 공통적으로 사용될 레이블들
//protocol LabelFactory {
//    func createLabel(with text: String, color: UIColor) -> UILabel
//}

class BaseLabelFactory {
    func createLabel(with text: String, color: UIColor) -> UILabel {
        let label = UILabel()
        label.textAlignment = .left
        label.text = text
        label.textColor = color
        label.numberOfLines = 0
        return label
    }
}

class LargeTitleLabel: BaseLabelFactory {
    override func createLabel(with text: String, color: UIColor) -> UILabel {
        let label = super.createLabel(with: text, color: color)
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }
}

class SmallTitleLabel: BaseLabelFactory {
    override func createLabel(with text: String, color: UIColor) -> UILabel {
        let label = super.createLabel(with: text, color: color)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }
}

class ContentLabel: BaseLabelFactory {
    override func createLabel(with text: String, color: UIColor) -> UILabel {
        let label = super.createLabel(with: text, color: color)
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        let fontSize: CGFloat = 16
        let kernValue = fontSize * -0.04
        label.attributedText = NSAttributedString(string: text, attributes: [
            .kern: kernValue,
            .foregroundColor: color
        ])
        return label
    }
}

class ContentBoldLabel: BaseLabelFactory {
    override func createLabel(with text: String, color: UIColor) -> UILabel {
        let label = super.createLabel(with: text, color: color)
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 0
        let fontSize: CGFloat = 16
        let kernValue = fontSize * -0.04
        label.attributedText = NSAttributedString(string: text, attributes: [
            .kern: kernValue,
            .foregroundColor: color
        ])
        return label
    }
}

// MARK: - 앱 전체에서 공통적으로 사용될 버튼

protocol ButtonFactory {
    func createButton(text: String, color: UIColor, textColor: UIColor) -> UIButton
}

class BaseButton: ButtonFactory {
    func createButton(text: String, color: UIColor, textColor: UIColor) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.backgroundColor = color
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }
}

class ActionButtonBlack {
    func createButton(text: String, color: UIColor, textColor: UIColor, method: @escaping () -> Void) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.backgroundColor = color
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addAction(UIAction(handler: { _ in
            method()
        }), for: .touchUpInside)
        return button
    }
}

class ActionButtonBlack2 {
    func createButton(text: String, color: UIColor, textColor: UIColor) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.backgroundColor = color
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        return button
    }
}

class ActionButtonBorder {
    func createButton(text: String, color: UIColor, textColor: UIColor) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.borderColor = color.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        return button
    }
}

// 사용예시

// 라벨생성시 color는 텍스트 컬러값입니다
//private let 자산플랜라벨 = LargeTitleLabel().createLabel(with: "자산플랜", color: UIColor.black)

// 버튼생성시 color는 버튼 색상 , textColor는 글자 색상입니다
//private let 테스트버튼 = BaseButton().createButton(text: "테스트", color: UIColor.systemBlue, textColor: UIColor.white)

// MARK: - 텍스트 필드 생성기

protocol TextFieldFactory {
    func createTextField(placeholder: String, textColor: UIColor) -> UITextField
}

// 공용
class BaseTextField: TextFieldFactory {
    func createTextField(placeholder: String, textColor: UIColor) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.textColor = textColor
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 5
        return textField
    }
}



extension UIColor {
    static let LargeTitleColor = UIColor(hex: "#060b11")
    static let mainGreen = UIColor(red: 0/255, green: 255/255, blue: 102/255, alpha: 1.0)
}


class LabelBuilder {
    private var text: String = ""
    private var color: UIColor = .black
    private var font: UIFont = .systemFont(ofSize: 16)
    private var align: NSTextAlignment = .left
    
    
    static let defaultLetterSpacing: CGFloat = 1.5

    static func applyDefaultLetterSpacing(to label: UILabel) {
        guard let text = label.text else { return }
        label.attributedText = NSAttributedString(string: text, attributes: [.kern: defaultLetterSpacing])
    }

    
    
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
    
    func build() -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = color
        label.font = font
        label.textAlignment = align
        label.numberOfLines = 0
        Self.applyDefaultLetterSpacing(to: label)
        return label
    }
}

class LabelFactory {
    static func LargeTitle() -> LabelBuilder {
        return LabelBuilder()
            .setFont(.systemFont(ofSize: 24))
            .setColor(.LargeTitleColor)
            .setAlign(.left)
    }
}
