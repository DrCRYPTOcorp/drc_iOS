//
//  NoticeTVC.swift
//  DrCRYPTO
//
//  Created by 갓거 on 2018. 8. 18..
//  Copyright © 2018년 Dr.CRYPTO. All rights reserved.
//

import UIKit

class NoticeTVC: UITableViewController {

    private func getData() -> [NoticeData?] {
        
        let firstContent = [ContentData(content: "2018년 8월 24일 Dr.CRYPTO 전격 출시")]
        let firstTitle = NoticeData(title: "Dr.CRYPTO 출시", contents: firstContent)
        
        let secondContent = [ContentData(content: "DRC 1000개 에어드랍 이벤트")]
        let secondTitle = NoticeData(title: "DRC 에어드랍", contents: secondContent)
        
        let thirdContent = [ContentData(content: "서울대병원, 을지대병원, 고려대병원, 인하대병원, 연세대병원, 순천향대병원, 한림성심대병원이 추가되었습니다.")]
        let thirdTitle = NoticeData(title: "Dr.CRYPTO 대학병원 추가", contents: thirdContent)
        
        
        return [firstTitle,secondTitle,thirdTitle]
    }
    
    var noticeData: [NoticeData?]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        self.title = "공지사항"
        
        noticeData = getData()
        
        self.tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        self.tableView.tableHeaderView = UIView.init(frame: CGRect.zero)
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    
    private func getParentCellIndex(expansionIndex: Int) -> Int {
        
        var selectedCell: NoticeData?
        var selectedCellIndex = expansionIndex
        
        while(selectedCell == nil && selectedCellIndex >= 0) {
            selectedCellIndex -= 1
            selectedCell = noticeData?[selectedCellIndex]
        }
        
        return selectedCellIndex
    }
    
    private func expandCell(tableView: UITableView, index: Int) {
        if let contents = noticeData?[index]?.contents {
            for i in 1...contents.count {
                noticeData?.insert(nil, at: index + i)
                tableView.insertRows(at: [NSIndexPath(row: index + i, section: 0) as IndexPath] , with: .top)
            }
        }
    }
    
    private func contractCell(tableView: UITableView, index: Int) {
        if let contents = noticeData?[index]?.contents {
            for i in 1...contents.count {
                noticeData?.remove(at: index+1)
                tableView.deleteRows(at: [NSIndexPath(row: index+1, section: 0) as IndexPath], with: .top)
                
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = noticeData {
            return data.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Row is DefaultCell
        if let rowData = noticeData?[indexPath.row] {
            let defaultCell = tableView.dequeueReusableCell(withIdentifier: "NoticeTitleCell", for: indexPath) as! NoticeTitleCell
            defaultCell.noticeTitleLabel.text = rowData.title
            defaultCell.downArrowImageView.image = #imageLiteral(resourceName: "Chevron")
            defaultCell.selectionStyle = .none
            
            return defaultCell
        }
            // Row is ExpansionCell
        else {
            if let rowData = noticeData?[getParentCellIndex(expansionIndex: indexPath.row)] {
                // Create an ExpansionCell
                let expansionCell = tableView.dequeueReusableCell(withIdentifier: "NoticeExpansionCell", for: indexPath) as! NoticeExpansionCell
                
                // Get the index of the parent Cell (containing the data)
                let parentCellIndex = getParentCellIndex(expansionIndex: indexPath.row)
                
                // Get the index of the flight data (e.g. if there are multiple ExpansionCells
                let contentIndex = indexPath.row - parentCellIndex - 1
                
                // Set the cell's data
                expansionCell.noticeDescriptionLabel.text = rowData.contents?[contentIndex].content
                
                expansionCell.selectionStyle = .none
                
                return expansionCell
            }
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let rowData = noticeData?[indexPath.row] {
            return 50
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let data = noticeData?[indexPath.row] {
            
            // If user clicked last cell, do not try to access cell+1 (out of range)
            if(indexPath.row + 1 >= (noticeData?.count)!) {
                expandCell(tableView: tableView, index: indexPath.row)
            }
            else {
                // If next cell is not nil, then cell is not expanded
                if(noticeData?[indexPath.row+1] != nil) {
                    expandCell(tableView: tableView, index: indexPath.row)
                    // Close Cell (remove ExpansionCells)
                } else {
                    contractCell(tableView: tableView, index: indexPath.row)
                    
                }
            }
        }
    }

}
