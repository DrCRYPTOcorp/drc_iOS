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
    @IBOutlet var medicalRecordSeeAllButton: UIButton!
    @IBOutlet var visitRecordSeeAllButton: UIButton!
    @IBOutlet var medicalRecordSeeAllStackView: UIStackView!
    @IBOutlet var visitRecordSeeAllStackView: UIStackView!
    @IBOutlet var noMedicalRecordLabel: UILabel!
    @IBOutlet var noVisitRecordLabel: UILabel!
    
    var medicalRecordData = [String]()
    var visitRecordData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        medicalRecordCollectionView.delegate = self
        medicalRecordCollectionView.dataSource = self
        visitRecordCollectionView.delegate = self
        
        navigationBarSetting()
        searchBarSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        noData()
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
        SearchController.searchBar.clipsToBounds = true
        SearchController.searchBar.layer.cornerRadius = 16
        SearchController.searchBar.barTintColor = UIColor.white
        SearchController.searchBar.isTranslucent = false
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
        if let textfield = SearchController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.white
            textfield.placeholder = ""
            textfield.alpha = 1.0
            if let backgroundview = textfield.subviews.first {
                backgroundview.backgroundColor = #colorLiteral(red: 0.2862745098, green: 0.8549019608, blue: 0.831372549, alpha: 1)
                backgroundview.layer.cornerRadius = 16
                backgroundview.clipsToBounds = true
            }
        }
        navigationItem.searchController = SearchController
    }
    
    func noData(){
        if medicalRecordData.count == 0{
            medicalRecordCollectionView.isHidden = true
            noMedicalRecordLabel.isHidden = false
            medicalRecordSeeAllStackView.isHidden = true
        }
        if visitRecordData.count == 0{
            visitRecordCollectionView.isHidden = true
            noVisitRecordLabel.isHidden = false
            visitRecordSeeAllStackView.isHidden = true
        }
    }
}

extension MedicalWalletVC : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.medicalRecordCollectionView {
            return medicalRecordData.count
        }
        else {
            return visitRecordData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.medicalRecordCollectionView{
            let cell = medicalRecordCollectionView.dequeueReusableCell(withReuseIdentifier: "MedicalRecordCell", for: indexPath) as! MedicalRecordCell
            //TODO
            return cell
        }
        else {
            let cell = visitRecordCollectionView.dequeueReusableCell(withReuseIdentifier: "VisitRecordCell", for: indexPath) as! VisitRecordCell
            //TODO
            return cell
        }
    }
    
    
    
    
}
