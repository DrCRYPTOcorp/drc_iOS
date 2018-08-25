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
        hospitalNameLabel.font = UIFont(name: "NanumBarunGothicBold", size: 14)
        diseaseNameLabel.font = UIFont(name: "NanumBarunGothicBold", size: 14)
        hospitalWalletAddressLabel.font = UIFont(name: "NanumBarunGothicLight", size: 12)
        drcLabel.font = UIFont(name: "NanumBarunGothicBold", size: 12)
        drcLabel.textColor = #colorLiteral(red: 0.9764705882, green: 0.6705882353, blue: 0.3019607843, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
