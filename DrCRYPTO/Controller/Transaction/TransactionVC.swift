//
//  TransactionVC.swift
//  DrCRYPTO
//
//  Created by 갓거 on 2018. 8. 10..
//  Copyright © 2018년 Dr.CRYPTO. All rights reserved.
//

import UIKit
import FirebaseDatabase

class TransactionVC : UIViewController {
    
    @IBOutlet var noTransactionImageView: UIImageView!
    @IBOutlet var transactionTableView: UITableView!
    
    var transactionData = [[String]]()
    let ud = UserDefaults.standard
    
    var hospitalData = [String]()
    var diseaseData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSetting()
        tableviewSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("history").child(gsno(ud.string(forKey: "uid"))).observeSingleEvent(of: .value, with: { snapShot in
            let userDic = snapShot.value as? [String]
            self.transactionData = [userDic] as! [[String]]
        })
        dataSetting()
        transactionTableView.reloadData()
    }
}

extension TransactionVC {
    
    func navigationBarSetting(){
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "NanumBarunGothicBold", size: 16)!]
    }
    
    func tableviewSetting(){
        transactionTableView.delegate = self
        transactionTableView.dataSource = self
        transactionTableView.tableFooterView = UIView.init(frame: CGRect.zero)
        transactionTableView.tableHeaderView = UIView.init(frame: CGRect.zero)
        transactionTableView.allowsSelection = false
    }
    
    func dataSetting(){
        if transactionData.count == 0{
            noTransactionImageView.isHidden = false
            transactionTableView.isHidden = true
        } else{
            noTransactionImageView.isHidden = true
            transactionTableView.isHidden = false
        }
    }
    
}

extension TransactionVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = transactionTableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionCell
        let index = transactionData[indexPath.row]
        cell.hospitalNameLabel.text = index[0]
        cell.diseaseNameLabel.text = index[1]
        cell.statusImageView.image = #imageLiteral(resourceName: "icRequest")
        cell.drcLabel.text = "30 DRC"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}
