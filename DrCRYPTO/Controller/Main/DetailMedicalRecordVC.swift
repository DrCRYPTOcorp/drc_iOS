//
//  DetailMedicalRecordVC.swift
//  DrCRYPTO
//
//  Created by 갓거 on 2018. 8. 17..
//  Copyright © 2018년 Dr.CRYPTO. All rights reserved.
//

import UIKit
import Hero

class DetailMedicalRecordVC : UIViewController {
    
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userGenderLabel: UILabel!
    @IBOutlet var userBirthLabel: UILabel!
    @IBOutlet var recordDateLabel: UILabel!
    @IBOutlet var medicalRecordTableView: UITableView!
    
    let ud = UserDefaults.standard
    var medicalRecordObjectNameArray : [String] = ["병명", "소견", "비고", "의료 기관명", "전화번호", "의사 면허번호", "담당 의사"]
    var medicalRecordData : [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameLabel.text = ud.string(forKey: "name")
        userGenderLabel.text = ud.string(forKey: "gender")
        userBirthLabel.text = ud.string(forKey: "birth")
        tableViewSetting()
    }
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendButtonAction(_ sender: Any) {
        let sendVC = self.storyboard!.instantiateViewController(withIdentifier: "SendMedicalRecordVC") as! SendMedicalRecordVC
        sendVC.hero.modalAnimationType = .fade
        hero.replaceViewController(with: sendVC)
    }
}

extension DetailMedicalRecordVC {
    
    func tableViewSetting(){
        medicalRecordTableView.delegate = self
        medicalRecordTableView.dataSource = self
        medicalRecordTableView.tableFooterView = UIView.init(frame: CGRect.zero)
        medicalRecordTableView.tableHeaderView = UIView.init(frame: CGRect.zero)
        medicalRecordTableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
}

extension DetailMedicalRecordVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicalRecordObjectNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = medicalRecordTableView.dequeueReusableCell(withIdentifier: "DetailMedicalRecordCell", for: indexPath) as! DetailMedicalRecordCell
        
        cell.objectNameLabel.text = medicalRecordObjectNameArray[indexPath.row]
        cell.descriptionLabel.text = medicalRecordData![indexPath.row]
        
        return cell
    }
    
    
    
}
