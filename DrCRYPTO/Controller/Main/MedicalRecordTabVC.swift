//
//  MedicalRecordTabVC.swift
//  DrCRYPTO
//
//  Created by 갓거 on 2018. 8. 10..
//  Copyright © 2018년 Dr.CRYPTO. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class MedicalRecordTabVC : UIViewController, IndicatorInfoProvider{
    
    @IBOutlet var recordCollectionView: UICollectionView!
    
    var itemInfo = IndicatorInfo(title: "진료 기록")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        recordCollectionView.reloadData()
    }
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }

}

extension MedicalRecordTabVC : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = recordCollectionView.dequeueReusableCell(withReuseIdentifier: "MedicalRecordCollectionViewCell", for: indexPath) as! MedicalRecordCollectionViewCell
        cell.test.text = "진료기록"
        print("asdasdas")
        return cell
    }
    
    
}
