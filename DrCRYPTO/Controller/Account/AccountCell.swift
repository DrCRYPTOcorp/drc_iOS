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
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
