//
//  TransactionCell.swift
//  DrCRYPTO
//
//  Created by 갓거 on 2018. 8. 15..
//  Copyright © 2018년 Dr.CRYPTO. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {

    @IBOutlet var statusImageView: UIImageView!
    @IBOutlet var hospitalWalletAddressLabel: UILabel!
    @IBOutlet var hospitalNameLabel: UILabel!
    @IBOutlet var separationLabel: UILabel!
    @IBOutlet var diseaseNameLabel: UILabel!
    @IBOutlet var drcLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
