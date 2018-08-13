//
//  MedicalRecordTabVC.swift
//  DrCRYPTO
//
//  Created by 갓거 on 2018. 8. 10..
//  Copyright © 2018년 Dr.CRYPTO. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class MedicalRecordTabVC : UIViewController, IndicatorInfoProvider, NetworkCallback{
    
    @IBOutlet var recordCollectionView: UICollectionView!
    
    var itemInfo = IndicatorInfo(title: "진료 기록")
    
    var responseMessage : UserProfileVO?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let model = UserProfileModel(self)
        model.test()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        recordCollectionView.reloadData()
    }
    
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    func networkResult(resultData: Any, code: String) {
        if code == "Success"{
            responseMessage = resultData as? UserProfileVO
            print(responseMessage?.detail)
        }
    }
    
    func networkFailed() {
        print("네트워크 에러")
    }

}

extension MedicalRecordTabVC : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = recordCollectionView.dequeueReusableCell(withReuseIdentifier: "MedicalRecordCollectionViewCell", for: indexPath) as! MedicalRecordCollectionViewCell
        cell.test.text = "진료기록"
        return cell
    }
    
    
}
