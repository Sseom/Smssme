//
//  BenefitView.swift
//  Smssme
//
//  Created by KimRin on 9/19/24.
//

import UIKit
import SnapKit

class BenefitView: UIView {
    let textView = UITextView()
    let currentBenefit: String
    
    let context: [String: String] =
    ["의료비":
"""
연말정산 시 근로자가 본인, 배우자 및 부양가족을 위해 지출한 의료비를 공제받을 수 있습니다.
총 급여액의 3%를 초과하는 금액에 대해 공제 가능.
일반 가족의 의료비는 연간 최대 700만 원까지 공제 가능.
공제 한도: 총급여의 3%를 초과하는 금액에 대해 공제
일반 의료비: 15% 공제
일반 가족의 의료비는 연간 최대 700만 원까지 공제 가능.
난임 시술비: 20% 공제
""",
     
     "주거비":
        """
 주거비 소득 공제
무주택 세대주가 주택 구입을 위해 주택청약저축, 주택담보대출 상환액 등에 대해 공제받을 수 있습니다.
주택청약저축 납입액: 납입금액의 40%, 연간 최대 240만 원.
장기주택저당차입금 이자상환액: 연간 1,500만 원 한도(주택 구입 자금 대출의 경우)

월세 세액공제
공제 한도:
연소득 7천만 원 이하: 월세 납입액의 10%
연소득 5천5백만 원 이하: 월세 납입액의 12%
연간 최대 750만 원까지 납입액 공제

""",
     
     "교육비":
        """
자녀나 본인의 교육비를 지출한 경우, 해당 금액을 소득공제 받을 수 있습니다.
공제 한도:
유치원 및 초중고 교복 구입비: 연간 50만 원 한도
초중고등학생: 연간 최대 300만 원
대학생: 연간 최대 900만 원
본인 대학원 교육비: 한도 없음.
""",
     
     "보험료":
        """

본인 또는 부양가족의 보장성 보험료 납입액에 대해 소득공제를 받을 수 있습니다.
공제 한도: 연간 100만 원 한도


국민연금, 공무원연금, 군인연금 등 공적연금에 납부한 금액에 대해 전액 소득공제를 받을 수 있습니다.
공제 한도: 납입액 전액 소득공제


연금저축이나 퇴직연금에 납입한 금액에 대해 세액공제를 받을 수 있습니다.
공제 한도:
총급여 5,500만 원 이하: 납입금액의 15%
총급여 5,500만 원 초과: 납입금액의 12%
연간 납입액 한도: 연금저축 최대 400만 원, 퇴직연금 포함 시 최대 700만 원


보장성 보험료 납입금액에 대해 세액공제를 받을 수 있습니다.
공제 한도: 납입액의 12%, 최대 100만 원 한도
""",
     "기부금":
        """


공익을 위해 기부한 금액은 세액공제가 가능합니다.

공제 한도:
법정기부금: 소득의 100%까지 (국가, 지방자치단체, 공익법인, 국립대학 등)
지정기부금: 소득의 30%까지 (종교단체, 사회복지단체, NGO 등)


기부금에 대해 세액공제를 받을 수 있습니다.

공제 한도:
기부금의 15% 세액공제
지정기부금 1천만 원 초과분은 30% 세액공제
""",
     
     "외식비":
        """
신용카드 사용액 공제 (외식비)
신용카드, 체크카드, 현금영수증 사용액에 대해 일정 비율 공제.

공제 한도:
연간 총 급여의 25%를 초과하는 사용액 중 일부에 대해 공제 가능.
신용카드: 초과 사용액의 15%
체크카드 및 현금영수증: 30%
도서, 공연 등 문화비: 30% 공제

한도:
총급여 7천만 원 이하: 최대 300만 원
총급여 7천만 원 초과 1억 2천만 원 이하: 최대 250만 원
총급여 1억 2천만 원 초과: 최대 200만 원
"""
     
     
     
     
    ]
    
    init(benefit: String) {
        self.currentBenefit = benefit
        super.init(frame: .zero)
        
        self.backgroundColor = .white
        configureUI()
        configureCurrentBenefit(currentText: benefit)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCurrentBenefit(currentText: String){
        if let textValue = self.context[currentText] {
            textView.text = textValue
        } else {
            textView.text = "오류"
        }
        
        
    }
    
    private func configureUI(){
        
        
        
        // 폰트 및 색상 설정
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .black
        
        // textView의 insets 설정
        textView.textContainerInset = UIEdgeInsets(top: 30, left: 30, bottom: 0, right: 30)
        textView.isScrollEnabled = true
        textView.isEditable = false
        self.addSubview(textView)
        textView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().inset(30)
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    
}
