//
//  ToastMessage.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/13/24.
//

import UIKit
import SnapKit

class Toast {
    static func show(message: String, in viewController: UIViewController, duration: Double = 2.0) {
        let toastLabel: UILabel = {
            let label = UILabel()
            label.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            label.textColor = UIColor.white
            label.textAlignment = .center
            label.font = .boldSystemFont(ofSize: 16)
            label.text = message
            label.alpha = 0.0 // 초기에 숨김 상태로 설정
            label.layer.cornerRadius = 16
            label.clipsToBounds = true
            
            // viewController의 뷰에 추가
             viewController.view.addSubview(label)
            
             // SnapKit으로 위치 및 크기 설정
             label.snp.makeConstraints {
                 $0.center.equalToSuperview()
//                 $0.centerX.equalTo(viewController.view)
//                 $0.top.equalTo(viewController.view.safeAreaLayoutGuide.snp.top).offset(30)
//                 $0.width.lessThanOrEqualTo(viewController.view).inset(20)
                 $0.height.equalTo(35)
             }
            return label
        }()

 
        // 애니메이션으로 토스트 메시지를 표시
        UIView.animate(withDuration: 0.5, animations: {
            toastLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }) { _ in
                toastLabel.removeFromSuperview()
            }
        }
    }
}
