//
//  AccountVC.swift
//  DrCRYPTO
//
//  Created by 갓거 on 2018. 8. 10..
//  Copyright © 2018년 Dr.CRYPTO. All rights reserved.
//

import UIKit
import FirebaseAuth
import IGIdenticon

class AccountVC : UIViewController {
    
    @IBOutlet var accountTableView: UITableView!
    
    let supportCellNameArray : [String] =  ["공지사항", "개인정보 처리방침", "오픈소스 라이센스"]
    
    var userUid : String?
    var userEmail : String?
    var userName : String?
    var userGender : String?
    var userBirth : String?
    var userAddress : String?
    
    let ud = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarSetting()
        tableViewSetting()
    }
}

extension AccountVC {
    
    func navigationBarSetting(){
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "NanumBarunGothicBold", size: 16)!]
    }
    
    func tableViewSetting(){
        accountTableView.delegate = self
        accountTableView.dataSource = self
        accountTableView.tableFooterView = UIView.init(frame: CGRect.zero)
        accountTableView.tableHeaderView = UIView.init(frame: CGRect.zero)
        accountTableView.estimatedRowHeight = 66
        
        userName = ud.string(forKey: "name")
        userEmail = ud.string(forKey: "email")
        userGender = ud.string(forKey: "gender")
        userBirth = ud.string(forKey: "birth")
        userUid = ud.string(forKey: "uid")
        userAddress = ud.string(forKey: "address")
    }
    
    @objc func logoutButtonAction(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            UserDefaults.standard.synchronize()
            let loginStoryboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
            let viewController = loginStoryboard.instantiateViewController(withIdentifier: "NavigaionVC") as! NavigaionVC
            UIApplication.shared.keyWindow?.rootViewController = viewController
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}

extension AccountVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 2
        } else if section == 2 {
            return 3
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = accountTableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! HeaderCell
        
        if section == 2 {
            header.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9764705882, blue: 0.9921568627, alpha: 1)
            header.headerLabel.font = UIFont(name: "NanumBarunGothicBold", size: 14)
            header.headerLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.42)
            header.headerLabel.text = "지원"
        }
        else if section == 3{
            header.headerLabel.text = ""
        }
        else {
            header.isHidden = true
        }

        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = accountTableView.dequeueReusableCell(withIdentifier: "UserAccountCell", for: indexPath) as! UserAccountCell
            cell.selectionStyle = .none
            cell.profileImageView.image = Identicon().icon(from: gsno(userAddress), size: CGSize(width: cell.profileImageView.frame.size.width, height: cell.profileImageView.frame.size.height))
            cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.width / 2
            cell.profileImageView.layer.masksToBounds = true
            cell.profileNameLabel.text = gsno(userName)
            cell.profileEmailLabel.text = gsno(userEmail)
            return cell
        case 1:
            let cell = accountTableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath) as! AccountCell
            cell.selectionStyle = .none
            if indexPath.row == 0{
                cell.accountObjectLabel.text = gsno(userAddress)
                cell.rightActionButton.setImage(#imageLiteral(resourceName: "icCopy"), for: .normal)
            } else{
                cell.accountObjectLabel.text = "내 정보 변경"
                cell.rightActionButton.setImage(#imageLiteral(resourceName: "chevron"), for: .normal)
            }
            return cell
            
        case 2:
            let cell = accountTableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath) as! AccountCell
            cell.selectionStyle = .none
            cell.accountObjectLabel.text = supportCellNameArray[indexPath.row]
            cell.rightActionButton.setImage(#imageLiteral(resourceName: "chevron"), for: .normal)
            return cell
        default:
            let cell = accountTableView.dequeueReusableCell(withIdentifier: "LogoutCell", for: indexPath) as! LogoutCell
            cell.logoutButton.addTarget(self, action: #selector(logoutButtonAction(_:)), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedCell : UITableViewCell = accountTableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.clear
        
        switch indexPath.section {
        case 0:
            break
        case 1:
            break
        case 2:
            //MARK: 공지사항
            if indexPath.row == 0{
                guard let noticeVC = storyboard?.instantiateViewController(
                    withIdentifier : "NoticeTVC"
                    ) as? NoticeTVC
                    else{return}
                self.navigationController?.pushViewController(noticeVC, animated: true)
            }
            
            //MARK: 개인정보 처리방침
            if indexPath.row == 1{
                guard let privacyVC = storyboard?.instantiateViewController(
                    withIdentifier : "PersonalPrivacyVC"
                    ) as? PersonalPrivacyVC
                    else{return}
                self.navigationController?.pushViewController(privacyVC, animated: true)
            }
        default:
            break
        }
    }
}
