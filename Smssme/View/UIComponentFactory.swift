//
//  UIComponentFactory.swift
//  Smssme
//
//  Created by 임혜정 on 8/26/24.
//

import UIKit

// MARK: - 앱 전체에서 공통적으로 사용될 레이블들
protocol LabelFactory {
    func createLabel(with text: String, color: UIColor) -> UILabel
}

class BaseLabelFactory: LabelFactory {
    func createLabel(with text: String, color: UIColor) -> UILabel {
        let label = UILabel()
        label.textAlignment = .left
        label.text = text
        label.textColor = color
        return label
    }
}

class LargeTitleLabel: BaseLabelFactory {
    override func createLabel(with text: String, color: UIColor) -> UILabel {
        let label = super.createLabel(with: text, color: color)
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }
}

class SmallTitleLabel: BaseLabelFactory {
    override func createLabel(with text: String, color: UIColor) -> UILabel {
        let label = super.createLabel(with: text, color: color)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }
}

class ContentLabel: BaseLabelFactory {
    override func createLabel(with text: String, color: UIColor) -> UILabel {
        let label = super.createLabel(with: text, color: color)
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }
}


// MARK: - 앱 전체에서 공통적으로 사용될 버튼

protocol ButtonFactory {
    func createButton() -> UIButton
}
