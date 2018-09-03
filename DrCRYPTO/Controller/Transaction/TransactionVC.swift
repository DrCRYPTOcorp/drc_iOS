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
    
    var sendDiseaseName : String?
    var sendHospitalName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSetting()
        tableviewSetting()
        recordLoading()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recordLoading()
    }
    
    //MARK: 결제완료 Noti 이벤트
    @objc func updateTransactionNoti(notification: NSNotification){
        recordLoading()
    }
}


extension TransactionVC {
    
    func recordLoading(){
        transactionData = [[String]]()
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.keepSynced(true)
        ref.child("records").child(gsno(ud.string(forKey: "uid"))).observeSingleEvent(of: .value, with: { snapShot in
            //MARK: 데이터 유효성 검사
            guard snapShot.exists() else{
                self.noTransactionImageView.isHidden = false
                self.transactionTableView.isHidden = true
                return
            }
            //MARK: 0:병명,1:소견,2:비고,3:병원이름,4:전화번호,5:의사면허,6:의사이름,7:방문시간
            let userRecord = snapShot.value as! Dictionary<String,Dictionary<String,String>>
            
            for firstKey in userRecord{
                var tempArray = [String]()
                for secondKey in firstKey.value{
                    tempArray.append(secondKey.value)
                }
                self.transactionData.append(tempArray)
            }
            self.transactionData = self.transactionData.sorted{ $0[7] > $1[7] }
            self.transactionTableView.reloadData()
            self.noData()
        })
    }
    
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
    
    func noData(){
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
        cell.hospitalNameLabel.text = index[6]
        cell.diseaseNameLabel.text = index[1]
        cell.hospitalWalletAddressLabel.text = index[7]
        cell.statusImageView.image = #imageLiteral(resourceName: "icRequest")
        cell.drcLabel.text = "30 DRC"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}
