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
    
    var name = ["서울대병원", "박성준신경외과", "최수호정형외과", "을지대병원", "연세세브란스병원"]
    var disease = ["허리 디스크", "감기", "목 디스크", "편도염", "인후염"]
    var day = ["2018-08-02", "2018-08-04", "2018-08-10", "2018-08-12", "2018-08-14"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        whiteImageView.isHidden = true
        medicalRecordCollectionView.delegate = self
        medicalRecordCollectionView.dataSource = self
        visitRecordCollectionView.delegate = self
        visitRecordCollectionView.dataSource = self
        
        navigationBarSetting()
        searchBarSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //noData()
    }
}

extension MedicalWalletVC : UISearchBarDelegate {
    
    func navigationBarSetting(){
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.01568627451, green: 0.7725490196, blue: 0.737254902, alpha: 1)
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
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
        SearchController.searchBar.layer.cornerRadius = 19
        SearchController.searchBar.barTintColor = UIColor.white
        SearchController.searchBar.isTranslucent = true
        SearchController.searchBar.tintColor = #colorLiteral(red: 0.01568627451, green: 0.7725490196, blue: 0.737254902, alpha: 1)
        
        //MARK: Magnifying Setting
        if let textFieldInsideSearchBar = SearchController.searchBar.value(forKey: "searchField") as? UITextField,
            let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView {
            
            glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
            glassIconView.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.87)
        }
        
        //MARK: SearchBar Scope Button Setting
        SearchController.searchBar.scopeButtonTitles = ["진료기록", "방문기록"]
        SearchController.searchBar.setScopeBarButtonTitleTextAttributes([NSAttributedStringKey.foregroundColor.rawValue: UIColor(red: 4/255.0, green: 197/255.0, blue: 188/255.0, alpha: 1.0)], for: .normal)
        
        //MARK : Cancel Button Setting
        let cancelButtonAttributes: NSDictionary = [NSAttributedStringKey.foregroundColor.rawValue: UIColor(red: 4/255.0, green: 197/255.0, blue: 188/255.0, alpha: 1.0)]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [NSAttributedStringKey : Any], for: UIControlState.normal)
        
        //MARK : SearchBar TextField Setting
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
        if let textfield = SearchController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.placeholder = ""
            textfield.alpha = 1.0
            if let backgroundview = textfield.subviews.first {
                backgroundview.backgroundColor = #colorLiteral(red: 0.4941176471, green: 0.8823529412, blue: 0.862745098, alpha: 0.72)
                backgroundview.layer.cornerRadius = 19
                backgroundview.clipsToBounds = true
            }
        }
        navigationItem.searchController = SearchController
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        whiteImageView.isHidden = false
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.black]
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.black
            textfield.placeholder = ""
            textfield.alpha = 1.0
            if let backgroundview = textfield.subviews.first {
                backgroundview.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                backgroundview.layer.cornerRadius = 19
                backgroundview.clipsToBounds = true
            }
        }
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        whiteImageView.isHidden = true
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.01568627451, green: 0.7725490196, blue: 0.737254902, alpha: 1)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.white
            textfield.placeholder = ""
            textfield.alpha = 1.0
            if let backgroundview = textfield.subviews.first {
                backgroundview.backgroundColor = #colorLiteral(red: 0.4941176471, green: 0.8823529412, blue: 0.862745098, alpha: 0.72)
                backgroundview.layer.cornerRadius = 19
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
            return day.count
        }
        else {
            return day.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.medicalRecordCollectionView{
            let cell = medicalRecordCollectionView.dequeueReusableCell(withReuseIdentifier: "MedicalRecordCell", for: indexPath) as! MedicalRecordCell
            cell.hospitalNameLabel.text = name[indexPath.row]
            cell.diseaseNameLabel.text = disease[indexPath.row]
            cell.issuedDateLabel.text = day[indexPath.row]
            cell.documentImageView.image = #imageLiteral(resourceName: "icon")
            
            cell.layer.cornerRadius = 6
            cell.layer.shadowColor = UIColor.gray.cgColor
            cell.layer.shadowOffset = CGSize(width: -2.0, height: 2.0)
            cell.layer.shadowRadius = 2.0
            cell.layer.shadowOpacity = 0.5
            cell.layer.masksToBounds = false
            cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
            return cell
        }
        else {
            let cell = visitRecordCollectionView.dequeueReusableCell(withReuseIdentifier: "VisitRecordCell", for: indexPath) as! VisitRecordCell
            cell.hospitalNameLabel.text = name[indexPath.row]
            cell.diseaseNameLabel.text = disease[indexPath.row]
            cell.visitingDateLabel.text = day[indexPath.row]
            
            cell.layer.cornerRadius = 4
            cell.layer.shadowColor = UIColor.gray.cgColor
            cell.layer.shadowOffset = CGSize(width: -2, height: 2)
            cell.layer.shadowRadius = 2.0
            cell.layer.shadowOpacity = 0.5
            cell.layer.masksToBounds = false
            cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
            return cell
        }
    }
    

    
    
    
}
