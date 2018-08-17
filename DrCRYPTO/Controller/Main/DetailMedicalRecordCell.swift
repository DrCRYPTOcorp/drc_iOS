//
//  DetailMedicalRecordCell.swift
//  DrCRYPTO
//
//  Created by 갓거 on 2018. 8. 18..
//  Copyright © 2018년 Dr.CRYPTO. All rights reserved.
//

import UIKit

class DetailMedicalRecordCell: UITableViewCell {

    @IBOutlet var objectNameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        objectNameLabel.font = UIFont(name: "NanumBarunGothic", size: 15)
        objectNameLabel.textColor = #colorLiteral(red: 0.7019607843, green: 0.7019607843, blue: 0.7019607843, alpha: 1)
        descriptionLabel.font = UIFont(name: "NanumBarunGothic", size: 16)
        descriptionLabel.textColor = #colorLiteral(red: 0.03921568627, green: 0.03921568627, blue: 0.03921568627, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
