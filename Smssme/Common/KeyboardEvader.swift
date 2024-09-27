//
//  KeyboardEvader.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/1/24.
//

import UIKit

/// 키보드로 인해 하단의 텍스트 필드 등이 가려질 때 자동으로 뷰가 올라가는 코드입니다
/// 사용하고자 하는 컨트롤러에서 상속 받은 후 사용하시면 됩니다. 
/// 적용된 부분이 궁금하시다면 EditUserInfoVC을 참고하시면 좋을 것 같습니다.
///
/// 사용 예)
/// var keyboardScrollView: UIScrollView { return signupView.scrollView}
///
/// override func viewDidLoad() {
///   super.viewDidLoad()
///   registerForKeyboardNotification()
///. }
protocol KeyboardEvader where Self: UIViewController {
    var keyboardScrollView: UIScrollView { get }
    func registerForKeyboardNotification()
}
extension KeyboardEvader where Self: UIViewController {
    func registerForKeyboardNotification() {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: OperationQueue.main
        ) { [weak self] notification in
            self?.keyboardWillShow(notification: notification)
        }
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: OperationQueue.main
        ) { [weak self] notification in
            self?.keyboardWillHide(notification: notification)
        }
    }
    private func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            assertionFailure("Couldn't get keyboard frame.")
            return
        }
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        keyboardScrollView.contentInset = insets
        keyboardScrollView.scrollIndicatorInsets = insets
    }
    private func keyboardWillHide(notification: Notification) {
        keyboardScrollView.contentInset = .zero
        keyboardScrollView.scrollIndicatorInsets = .zero
    }
}
