//
//  DetailMedicalRecordVC.swift
//  DrCRYPTO
//
//  Created by 갓거 on 2018. 8. 17..
//  Copyright © 2018년 Dr.CRYPTO. All rights reserved.
//

import UIKit

class DetailMedicalRecordVC : UIViewController {
    
    @IBOutlet var medicalRecordTableView: UITableView!
    
    var medicalRecordObjectNameArray : [String] = ["병명", "소견", "비고", "의료 기관명", "전화번호", "의사 면허번호", "담당 의사"]
    var medicalRecordData : [String] = ["123123", "23232asdasdasdasdasdasdasdasdasdasdasdasdasd3", "123123123123", "3434343434", "34343434", "asdasdasdasd", "asdasdkvkcvd"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetting()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
        cell.descriptionLabel.text = medicalRecordData[indexPath.row]
        
        return cell
    }
    
    
    
}
