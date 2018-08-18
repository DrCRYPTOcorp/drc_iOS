//
//  NoticeTitleCell.swift
//  DrCRYPTO
//
//  Created by 갓거 on 2018. 8. 18..
//  Copyright © 2018년 Dr.CRYPTO. All rights reserved.
//

import UIKit

class NoticeTitleCell: UITableViewCell {

    @IBOutlet var noticeTitleLabel: UILabel!
    @IBOutlet var downArrowImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        noticeTitleLabel.font = UIFont(name: "NanumBarunGothicBold", size: 15)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
