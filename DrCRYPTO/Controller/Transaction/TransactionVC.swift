//
//  TransactionVC.swift
//  DrCRYPTO
//
//  Created by 갓거 on 2018. 8. 10..
//  Copyright © 2018년 Dr.CRYPTO. All rights reserved.
//

import UIKit

class TransactionVC : UIViewController {
    
    @IBOutlet var noTransactionImageView: UIImageView!
    @IBOutlet var transactionTableView: UITableView!
    
    var transactionData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSetting()
        tableviewSetting()
        dataSetting()
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
        
        return cell
    }
    
    
}
