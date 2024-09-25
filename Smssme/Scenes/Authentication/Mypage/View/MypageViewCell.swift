//
//  MypageViewCell.swift
//  Smssme
//
//  Created by ahnzihyeon on 9/3/24.
//

import UIKit

class MypageViewCell: UITableViewCell {

    let cellTitleLabel = LabelFactory.subTitleLabel().build()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
 
//        cellTitleLabel.font = UIFont.systemFont(ofSize: 16)
//        cellTitleLabel.textColor = .black
        
        contentView.addSubview(cellTitleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
    }
    
}
