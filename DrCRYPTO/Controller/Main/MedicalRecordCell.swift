//
//  MedicalRecordCell.swift
//  DrCRYPTO
//
//  Created by 갓거 on 2018. 8. 14..
//  Copyright © 2018년 Dr.CRYPTO. All rights reserved.
//

import UIKit

class MedicalRecordCell : UICollectionViewCell {
    
    @IBOutlet var issuedDateLabel: UILabel!
    @IBOutlet var documentImageView: UIImageView!
    @IBOutlet var hospitalNameLabel: UILabel!
    @IBOutlet var diseaseNameLabel: UILabel!
    @IBOutlet var recordImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}
