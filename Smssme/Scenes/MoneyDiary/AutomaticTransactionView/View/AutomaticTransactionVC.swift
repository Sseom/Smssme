//
//  AutomaticTransactionVC.swift
//  Smssme
//
//  Created by KimRin on 9/12/24.
//코드검토 (2024.09.15)// 정규표현식 이해의 대한 어려움
//어떻게 풀어서 쓸것이며 어떻게 더 정확히 값을 뽑아낼수있을까 

import UIKit
import SnapKit
import RxSwift
//
class AutomaticTransactionVC: UIViewController {
    private let automaticView = AutomaticTransactionView()
    
    var transactionItem = TransactionItem() // out
    
    private let viewModel = AutomaticViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        observeState()
        
    }
    
    
    func setupUI() {
        [
            automaticView
        ].forEach { view.addSubview($0) }
        //사용방법 버튼 구성?
        self.automaticView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        automaticView.submitButton.addTarget(self, action: #selector(saveData), for: .touchUpInside)
    }
    
    
    private func observeState() {
        //viewModel.state값을 구독함
        viewModel.state
        //여기서
            .observe(on: MainScheduler.instance)
        //구독한 값을 가지고
            .subscribe(
            //들어오는거지 구독했으니까 근데 그게 state라는애고
            onNext: { state in
                //여기서 state의 condition을 체크하고
                switch state {
                    // 여기서는 성공/실패 에대한케이스 밖에 없음
                    // 그래서 성공시에는
                case .onSaveComplete(let completeTitle, let completeMessage):
                    self.showAlert(title: completeTitle, message: completeMessage, isComplete: true)
                    
                case .onSaveFail(let errorTitle, let errorMessage):
                    self.showAlert(title: errorTitle, message: errorMessage)
                }
                
            }
            
        ).disposed(by: self.disposeBag)
    }
    
    
    //alert은 동일하게 띄우지만 text 값이 다름, 재사용성
    func showAlert(title: String, message: String, isComplete: Bool = false) {
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            if(isComplete){
            
                self.dismiss(animated: true)
            }
        }
        
        alertController.addAction(okAction)
        
        alertController.title = title
        alertController.message = message
        
        present(alertController, animated: true, completion: nil)
        
    }


    @objc func saveData() {
        let text = automaticView.inputTextView.text
        viewModel.onAction(action: AutomaticAction.onSave(text))
    }

}

extension String {
    mutating func replace(at index: Int, with newChar: Character) {
        // 문자열의 인덱스를 계산
        let stringIndex = self.index(self.startIndex, offsetBy: index)
        
        // 기존 문자열을 배열로 변환하여 문자 교체
        self.replaceSubrange(stringIndex...stringIndex, with: String(newChar))
    }
    
    
    struct 입력 //Input
    {//버튼누르기
        //transaction viewmodel에서 처리
        
    }
    struct 출력 // OUTPUT 
    {
        //alert을 보여준다 성/실 -> 공통된UI의 text다른차이뿐 -> 전달해서 alert으로 output을 보낸다.
        //성공시 ->데이터저장 후. 얼럿 -> ㄴㅅㅁㅅㄷrk 퍄냐ㅠㅣㄷ ㅐㄱ ㅜㅐㅅ
        /* 뷰 입력 -> 출력 입력에 의해서 뷰의 상태의 변경?  화면 보여줄게 알럿뿐
         버튼누르기가 들어왓다 인풋들어옴 로직처리 -> 아웃이 나간다
         텍스트필드에 택스트를 가져와야함 -> 그런후 로직처리
         검증 처리
         실패시 -> 알럿 // 실패스트링 // 얼럿을 아웃풋으로 vc에 던지고 vc에서 얼럿을띄워줌
         성공시 -> 저장//코어데이터로 // 얼럿을 아웃풋으로 성공스트링과 던진다.
         ......................
         */
    }
}

