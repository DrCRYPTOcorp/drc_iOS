//
//  AccountCell.swift
//  DrCRYPTO
//
//  Created by 갓거 on 2018. 8. 16..
//  Copyright © 2018년 Dr.CRYPTO. All rights reserved.
//

import UIKit

class AccountCell: UITableViewCell {

    @IBOutlet var accountObjectLabel: UILabel!
    @IBOutlet var rightActionButton: UIButton!
    @IBOutlet var moneyLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        moneyLabel.font = UIFont(name: "NanumBarunGothicBold", size: 14)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
