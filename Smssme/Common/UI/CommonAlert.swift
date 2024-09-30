//
//  CommonAlert.swift
//  Smssme
//
//  Created by ahnzihyeon on 8/29/24.
//

import UIKit

extension UIViewController {
    
    /**
     사용예시)
     showAlert(message: "\(error)", AlertTitle: "로그인 실패", buttonClickTitle: "확인")
     
     동기 사용예시)
     showSnycAlert(message: "테스트", AlertTitle: "테스트", buttonClickTitle: "테스트", method: test)
     
     func test() { print("얼럿창 테스트입니다. ") }
     */
    
    //MARK: - 비동기처리 Alert 호출
    /// - Parameters:
    ///   - message: 얼럿창에 들어가는 문구 입니다.
    ///   - AlertTitle: 얼럿창의 타이틀 입니다.
    ///   - buttonClickTitle: 얼럿창의 버튼에 해당하는 타이틀입니다. 버튼은 하나입니다.
    func showAlert(
        message: String,
        AlertTitle: String,
        buttonClickTitle: String
    ) {
        let alert = UIAlertController(title: AlertTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonClickTitle, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert2(
        message: String,
        AlertTitle: String,
        leftButtonTitle: String,
        rightButtonTitle: String
    ) {
        let alert = UIAlertController(title: AlertTitle, message: message, preferredStyle: .alert)
        
        let leftButton = UIAlertAction(title: leftButtonTitle, style: .default, handler: nil)
        let rightButton = UIAlertAction(title: rightButtonTitle, style: .default, handler: nil)
        
        [leftButton, rightButton].forEach { alert.addAction($0) }

        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - 동기처리 Alert 호출
    /// - Parameters:
    ///   - message: 얼럿창에 들어가는 문구 입니다.
    ///   - AlertTitle: 얼럿창의 타이틀 입니다.
    ///   - buttonClickTitle: 얼럿창의 버튼에 해당하는 타이틀입니다. 버튼은 하나입니다.
    ///   - method: 버튼이 클릭 되고 실행되어야 하는 로직이 클로저로 들어갑니다.
    func showSnycAlert(
        message: String,
        AlertTitle: String,
        buttonClickTitle: String,
        method: @escaping () -> Void
    ) {
        let alert = UIAlertController(title: AlertTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonClickTitle, style: .default, handler: { _ in
            method()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func showSnycAlert2(
        message: String,
        AlertTitle: String,
        leftButtonTitle: String,
        leftButtonmethod: @escaping () -> Void,
        rightButtonTitle: String,
        rightButtonmethod: @escaping () -> Void
    ) {
        let alert = UIAlertController(title: AlertTitle, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: leftButtonTitle, style: .default, handler: { _ in
            leftButtonmethod()
        }))
        alert.addAction(UIAlertAction(title: rightButtonTitle, style: .default, handler: { _ in
            rightButtonmethod()
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
}
