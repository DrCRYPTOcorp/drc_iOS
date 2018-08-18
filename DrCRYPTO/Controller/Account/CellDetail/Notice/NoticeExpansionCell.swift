//
//  NoticeExpansionCell.swift
//  DrCRYPTO
//
//  Created by 갓거 on 2018. 8. 18..
//  Copyright © 2018년 Dr.CRYPTO. All rights reserved.
//

import UIKit

class NoticeExpansionCell: UITableViewCell {

    @IBOutlet var noticeDescriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        noticeDescriptionLabel.font = UIFont(name: "NanumBarunGothic", size: 12)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
