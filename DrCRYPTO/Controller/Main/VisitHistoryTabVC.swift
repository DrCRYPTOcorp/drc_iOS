//
//  VisitHistoryTabVC.swift
//  DrCRYPTO
//
//  Created by 갓거 on 2018. 8. 10..
//  Copyright © 2018년 Dr.CRYPTO. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class VisitHistoryTabVC : UIViewController, IndicatorInfoProvider {
    
    @IBOutlet var historyTableView: UITableView!
    
    var itemInfo = IndicatorInfo(title: "방문 기록")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        historyTableView.reloadData()
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }

}

extension VisitHistoryTabVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyTableView.dequeueReusableCell(withIdentifier: "VisitHistoryTableViewCell", for: indexPath) as! VisitHistoryTableViewCell
        cell.hospitalName.text = "서울대병원"
        cell.hospitalCategory.text = "신경외과"
        cell.doctorName.text = "박성준"
        cell.transactionStatus.text = "발급"
        cell.transactionTimeStamp.text = "2018-08-11"
        cell.transactionCost.text = "10 DRC"
        cell.transactionCommission.text = "2 DRC"
        
        return cell
    }
    
    
}
