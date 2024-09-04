//
//  TestTableViewCell.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/4/24.
//

import UIKit

class TestTableViewCell: UITableViewCell {

    // 셀 안에 들어갈 UI 요소들 정의
       let myLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // UI 요소들 설정 및 추가
               myLabel.font = UIFont.systemFont(ofSize: 16)
               myLabel.textColor = .black
               contentView.addSubview(myLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
