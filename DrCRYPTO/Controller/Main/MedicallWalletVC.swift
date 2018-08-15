//
//  MedicallWalletVC.swift
//  DrCRYPTO
//
//  Created by 갓거 on 2018. 8. 14..
//  Copyright © 2018년 Dr.CRYPTO. All rights reserved.
//

import UIKit

class MedicalWalletVC : UIViewController {
    
    @IBOutlet var whiteImageView: UIImageView!
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
        whiteImageView.isHidden = true
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

extension MedicalWalletVC : UISearchBarDelegate {
    
    func navigationBarSetting(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "NanumBarunGothicBold", size: 28)!]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white]
    }
    
    func searchBarSetting(){
        let SearchController = UISearchController(searchResultsController: SearchVC())
        SearchController.searchBar.delegate = self
        SearchController.searchBar.clipsToBounds = true
        SearchController.searchBar.layer.cornerRadius = 16
        SearchController.searchBar.barTintColor = UIColor.white
        SearchController.searchBar.isTranslucent = false
        
        //MARK: SearchBar Scope Button Setting
        SearchController.searchBar.scopeButtonTitles = ["진료기록", "방문기록"]
        SearchController.searchBar.setScopeBarButtonTitleTextAttributes([NSAttributedStringKey.foregroundColor.rawValue: UIColor(red: 4/255.0, green: 197/255.0, blue: 188/255.0, alpha: 1.0)], for: .normal)
        SearchController.searchBar.tintColor = #colorLiteral(red: 0, green: 0.7831496, blue: 0.7580105662, alpha: 1)
        
        //MARK : Cancel Button Setting
        let cancelButtonAttributes: NSDictionary = [NSAttributedStringKey.foregroundColor.rawValue: UIColor(red: 4/255.0, green: 197/255.0, blue: 188/255.0, alpha: 1.0)]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [NSAttributedStringKey : Any], for: UIControlState.normal)
        
        //MARK : SearchBar TextField Setting
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
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        whiteImageView.isHidden = false
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.black]
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.white
            textfield.placeholder = ""
            textfield.alpha = 1.0
            if let backgroundview = textfield.subviews.first {
                backgroundview.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                backgroundview.layer.cornerRadius = 16
                backgroundview.clipsToBounds = true
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        whiteImageView.isHidden = true
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.white
            textfield.placeholder = ""
            textfield.alpha = 1.0
            if let backgroundview = textfield.subviews.first {
                backgroundview.backgroundColor = #colorLiteral(red: 0, green: 0.7831496, blue: 0.7580105662, alpha: 1)
                backgroundview.layer.cornerRadius = 16
                backgroundview.clipsToBounds = true
            }
        }
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
