//
//  MedicallWalletVC.swift
//  DrCRYPTO
//
//  Created by 갓거 on 2018. 8. 14..
//  Copyright © 2018년 Dr.CRYPTO. All rights reserved.
//

import UIKit

class MedicalWalletVC : UIViewController {
    
    @IBOutlet var medicalRecordCollectionView: UICollectionView!
    @IBOutlet var visitRecordCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        medicalRecordCollectionView.delegate = self
        medicalRecordCollectionView.dataSource = self
        visitRecordCollectionView.delegate = self
        visitRecordCollectionView.dataSource = self
        navigationBarSetting()
        searchBarSetting()
    }
}

extension MedicalWalletVC {
    
    func navigationBarSetting(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "NanumBarunGothicBold", size: 28)!]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white]
    }
    
    func searchBarSetting(){
        let SearchController = UISearchController(searchResultsController: nil)
        SearchController.searchBar.setImage(#imageLiteral(resourceName: "search"), for: UISearchBarIcon.search, state: .normal)
        SearchController.searchBar.barTintColor = UIColor.white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
        navigationItem.searchController = SearchController
    }
}

extension MedicalWalletVC : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.medicalRecordCollectionView {
            return 10
        }
        else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.medicalRecordCollectionView{
            let cell = medicalRecordCollectionView.dequeueReusableCell(withReuseIdentifier: "MedicalRecordCell", for: indexPath) as! MedicalRecordCell
            cell.testCardImageView.image = #imageLiteral(resourceName: "card")
            return cell
        }
        else {
            let cell = visitRecordCollectionView.dequeueReusableCell(withReuseIdentifier: "VisitRecordCell", for: indexPath) as! VisitRecordCell
            cell.testSmallCardImageView.image = #imageLiteral(resourceName: "invalidName")
            return cell
        }
    }
    
    
    
    
}
