//
//  MedicallWalletVC.swift
//  DrCRYPTO
//
//  Created by 갓거 on 2018. 8. 14..
//  Copyright © 2018년 Dr.CRYPTO. All rights reserved.
//

import UIKit
import web3swift
import BigInt
import SwiftyJSON
import FirebaseDatabase

extension Notification.Name{
    static let paidMedicalRecordNoti = Notification.Name("paidMedicalRecordNoti")
    static let updateTransactionNoti = Notification.Name("updateTransactionNoti")
}


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
    
    var singleMedicalRecordData = [String]()
    var totalMedicalRecordData = [[String]]()
    var showMedicalRecordData = [[String]]()
    var visitRecordData = [String]()
    var userMedicalRecordCount = 0
    
    var userName : String?
    var userAddress : String?
    let ud = UserDefaults.standard

    //MARK: Blockchain
//    let contractAddress = EthereumAddress("0x0234ca218c4af802072950dffb8680a29922f3e7")
    let contractAddress = EthereumAddress("0xb807ec8c17282d0892029c54354a14e381942f46")
    var web3Rinkeby:web3?
    var bip32keystore:BIP32Keystore?
    var keystoremanager:KeystoreManager?
    var contract:web3.web3contract?
    var tokenName:String?
    
    var accountABI = "[{\"constant\": true, \"inputs\": [{\"name\": \"\", \"type\": \"address\"}], \"name\": \"addressStructs\", \"outputs\": [{\"name\": \"index\", \"type\": \"uint256\"}, {\"name\": \"isAddress\", \"type\": \"bool\"}], \"payable\": false, \"stateMutability\": \"view\", \"type\": \"function\"}, {\"constant\": true, \"inputs\": [{\"name\": \"patientAddress\", \"type\": \"address\"}], \"name\": \"getMedicalRecordCount\", \"outputs\": [{\"name\": \"count\", \"type\": \"uint256\"}], \"payable\": false, \"stateMutability\": \"view\", \"type\": \"function\"}, {\"constant\": false, \"inputs\": [{\"name\": \"index\", \"type\": \"uint256\"}, {\"name\": \"patientAddress\", \"type\": \"address\"}, {\"name\": \"diseaseName\", \"type\": \"string\"}, {\"name\": \"doctorOpinion\", \"type\": \"string\"}, {\"name\": \"note\", \"type\": \"string\"}, {\"name\": \"hospitalName\", \"type\": \"string\"}, {\"name\": \"hospitalPhoneNumber\", \"type\": \"string\"}, {\"name\": \"doctorLisenceNumber\", \"type\": \"string\"}, {\"name\": \"doctorName\", \"type\": \"string\"}, {\"name\": \"timestamp\", \"type\": \"string\"}], \"name\": \"appendMedicalRecord\", \"outputs\": [{\"name\": \"success\", \"type\": \"bool\"}], \"payable\": false, \"stateMutability\": \"nonpayable\", \"type\": \"function\"}, {\"constant\": true, \"inputs\": [{\"name\": \"fetch\", \"type\": \"address\"}, {\"name\": \"index\", \"type\": \"uint256\"}], \"name\": \"getUserMedicalStruct\", \"outputs\": [{\"name\": \"\", \"type\": \"uint256\"}, {\"name\": \"\", \"type\": \"bool\"}, {\"name\": \"\", \"type\": \"string\"}, {\"name\": \"\", \"type\": \"string\"}, {\"name\": \"\", \"type\": \"string\"}], \"payable\": false, \"stateMutability\": \"view\", \"type\": \"function\"}, {\"constant\": true, \"inputs\": [{\"name\": \"fetch\", \"type\": \"address\"}, {\"name\": \"index\", \"type\": \"uint256\"}], \"name\": \"getHospitalStruct\", \"outputs\": [{\"name\": \"\", \"type\": \"string\"}, {\"name\": \"\", \"type\": \"string\"}, {\"name\": \"\", \"type\": \"string\"}, {\"name\": \"\", \"type\": \"string\"}, {\"name\": \"\", \"type\": \"string\"}], \"payable\": false, \"stateMutability\": \"view\", \"type\": \"function\"}, {\"constant\": true, \"inputs\": [], \"name\": \"token\", \"outputs\": [{\"name\": \"\", \"type\": \"address\"}], \"payable\": false, \"stateMutability\": \"view\", \"type\": \"function\"}, {\"inputs\": [], \"payable\": false, \"stateMutability\": \"nonpayable\", \"type\": \"constructor\"}, {\"anonymous\": false, \"inputs\": [{\"indexed\": false, \"name\": \"sender\", \"type\": \"address\"}, {\"indexed\": false, \"name\": \"patientAddress\", \"type\": \"address\"}, {\"indexed\": false, \"name\": \"index\", \"type\": \"uint256\"}], \"name\": \"LogPatient\", \"type\": \"event\"}]"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName = ud.string(forKey: "name")
        self.navigationController?.navigationBar.topItem?.title = gsno(userName) + "님"
        self.tabBarController?.title = "의료 기록"
        whiteImageView.isHidden = true
        medicalRecordCollectionView.delegate = self
        medicalRecordCollectionView.dataSource = self
        visitRecordCollectionView.delegate = self
        visitRecordCollectionView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(paidMedicalRecordNoti), name: .paidMedicalRecordNoti, object: nil)
        print(ud.string(forKey: "address"))
        navigationBarSetting()
        searchBarSetting()
        getBlockChainData()
        recordLoading()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    func recordLoading(){
        showMedicalRecordData = [[String]]()
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.keepSynced(true)
        ref.child("records").child(gsno(ud.string(forKey: "uid"))).observeSingleEvent(of: .value, with: { snapShot in
            //MARK: 데이터 유효성 검사
            guard snapShot.exists() else{
                print("Data doesn't exist")
                return
            }
            //MARK: 0:병명,1:소견,2:비고,3:병원이름,4:전화번호,5:의사면허,6:의사이름,7:방문시간
            let userRecord = snapShot.value as! Dictionary<String,Dictionary<String,String>>
            
            for firstKey in userRecord{
                var tempArray = [String]()
                for secondKey in firstKey.value{
                    tempArray.append(secondKey.value)
                }
                self.showMedicalRecordData.append(tempArray)
            }
            self.showMedicalRecordData = self.showMedicalRecordData.sorted{ $0[7] > $1[7] }
            self.medicalRecordCollectionView.reloadData()
            self.noData()
        })
    }
    
    //MARK: 결제완료 Noti 이벤트
    @objc func paidMedicalRecordNoti(notification: NSNotification){
        let indexData = notification.userInfo!["index"] as! [String]
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.keepSynced(true)
        //MARK: Firebase Database Record Data Save - UID 구분
        ref.child(
            "records/\(gsno(ud.string(forKey: "uid")))/\(gsno(indexData[7]))"
            ).setValue([
               "a" : indexData[0],
               "b" : indexData[1],
               "c" : indexData[2],
               "d" : indexData[3],
               "e" : indexData[4],
               "f" : indexData[5],
               "g" : indexData[6],
               "h" : indexData[7]
        ])
        recordLoading()
        NotificationCenter.default.post(name: .updateTransactionNoti, object: nil, userInfo: nil)
    }
    
}

extension MedicalWalletVC : UISearchBarDelegate {
    
    
    func drcBalanceData(){
    }
    
    
    func getBlockChainData(){
        let accessToken : String = "7600d818c4084a56953378cdf14a15df"
        web3Rinkeby = Web3.InfuraRinkebyWeb3(accessToken: accessToken)
        let userDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let path = userDir+"/keystore/"
        keystoremanager =  KeystoreManager.managerForPath(path, scanForHDwallets: true, suffix: "json")
        self.web3Rinkeby?.addKeystoreManager(self.keystoremanager)
        self.bip32keystore = self.keystoremanager?.bip32keystores[0]
        
        //MARK: Ether GET
        self.userAddress = self.bip32keystore?.addresses?.first?.address
        let ethAdd = EthereumAddress(gsno(userAddress))
        let balancebigint = web3Rinkeby?.eth.getBalance(address: ethAdd!).value
        ud.setValue(gsno(String(describing: Web3.Utils.formatToEthereumUnits(balancebigint ?? 0)!)), forKey: "ETH")
        let gasPriceResult = web3Rinkeby?.eth.getGasPrice()
        guard case .success(let gasPrice)? = gasPriceResult else {return}
        var options = Web3Options()
        options.gasPrice = gasPrice
        options.from = ethAdd
        
        //MARK: DRC Balance GET
        let contractAddress = EthereumAddress("0xdf88d798e9f9b916c25db739b939a27d8f80c0ad")!
        let contract = web3Rinkeby?.contract(Web3.Utils.erc20ABI, at: contractAddress, abiVersion: 2)! // utilize precompiled ERC20 ABI for your concenience
        guard let drcBalanceResult = contract?.method("balanceOf", parameters: [ethAdd] as [AnyObject], options: options)?.call(options: nil) else {return} // encode parameters for transaction
        guard case .success(let drcBalance) = drcBalanceResult, let drc = drcBalance["0"] else {return}
        
        ud.setValue(gsno(String(describing: drc)), forKey: "DRC")
        ud.synchronize()

        
        
        //MARK: 토큰 이름 불러오기
        self.contract = self.web3Rinkeby?.contract(accountABI, at: self.contractAddress, abiVersion: 2)!
        let getMedicalRecordCount = self.contract?.method("getMedicalRecordCount", parameters:[ethAdd]as[AnyObject],  options: options)
        guard let resCount = getMedicalRecordCount?.call(options: options) else {return}
        guard case .success(let resultCount) = resCount else {return}
        let stringCount = String(describing: resultCount["0"]!)
        let count = Int(stringCount)
        for i in 0..<gino(count){
            getUserMedicalFromBlockchain(ethAdd!, i, options: options)
            getHospitalFromBlockchain(ethAdd!, i, options: options)
            totalMedicalRecordData.append(singleMedicalRecordData)
            singleMedicalRecordData.removeAll()
        }
        totalMedicalRecordData = totalMedicalRecordData.sorted{ $0[7] > $1[7] }
        noData()
        medicalRecordCollectionView.reloadData()
        visitRecordCollectionView.reloadData()
    }
    
    
    func getUserMedicalFromBlockchain(_ ethAdd: EthereumAddress, _ index: Int, options: Web3Options){
        let getUserMedicalStruct = self.contract?.method("getUserMedicalStruct", parameters:[ethAdd, index]as[AnyObject],  options: options)
        guard let resUserMedical = getUserMedicalStruct?.call(options: options) else {return}
        guard case .success(let resultUserMedical) = resUserMedical else {return}
        let diseaseName = String(describing: resultUserMedical["2"]!)
        let doctorOpinion = String(describing: resultUserMedical["3"]!)
        let note = String(describing: resultUserMedical["4"]!)
        singleMedicalRecordData.append(diseaseName)
        singleMedicalRecordData.append(doctorOpinion)
        singleMedicalRecordData.append(note)
    }
    
    func getHospitalFromBlockchain(_ ethAdd: EthereumAddress, _ index: Int, options: Web3Options){
        let getHospitalStruct = self.contract?.method("getHospitalStruct", parameters:[ethAdd, index]as[AnyObject],  options: options)
        guard let resHospitalMedical = getHospitalStruct?.call(options: options) else {return}
        guard case .success(let resultHospital) = resHospitalMedical else {return}
        let hospitalName = String(describing: resultHospital["0"]!)
        let hospitalPhoneNumber = String(describing: resultHospital["1"]!)
        let doctorLicense = String(describing: resultHospital["2"]!)
        let doctorName = String(describing: resultHospital["3"]!)
        let timeStamp = String(describing: resultHospital["4"]!)
        
        singleMedicalRecordData.append(hospitalName)
        singleMedicalRecordData.append(hospitalPhoneNumber)
        singleMedicalRecordData.append(doctorLicense)
        singleMedicalRecordData.append(doctorName)
        singleMedicalRecordData.append(timeStamp)
    }
    
    func navigationBarSetting(){
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.01568627451, green: 0.7725490196, blue: 0.737254902, alpha: 1)
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
        if showMedicalRecordData.count == 0{
            medicalRecordCollectionView.isHidden = true
            noMedicalRecordLabel.isHidden = false
            medicalRecordSeeAllStackView.isHidden = true
        } else{
            medicalRecordCollectionView.isHidden = false
            noMedicalRecordLabel.isHidden = true
            medicalRecordSeeAllStackView.isHidden = false
        }
        if totalMedicalRecordData.count == 0{
            visitRecordCollectionView.isHidden = true
            noVisitRecordLabel.isHidden = false
            visitRecordSeeAllStackView.isHidden = true
        } else{
            visitRecordCollectionView.isHidden = false
            noVisitRecordLabel.isHidden = true
            visitRecordSeeAllStackView.isHidden = false
        }
    }
}

extension MedicalWalletVC : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.medicalRecordCollectionView {
            return showMedicalRecordData.count
        }
        else {
            return totalMedicalRecordData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //MARK: 0:병명,1:소견,2:비고,3:병원이름,4:전화번호,5:의사면허,6:의사이름,7:방문시간
        if collectionView == self.medicalRecordCollectionView{
            let cell = medicalRecordCollectionView.dequeueReusableCell(withReuseIdentifier: "MedicalRecordCell", for: indexPath) as! MedicalRecordCell
            if showMedicalRecordData.count != 0{
                let showIndex = showMedicalRecordData[indexPath.row]
                cell.hospitalNameLabel.text = showIndex[6]
                cell.diseaseNameLabel.text = showIndex[1]
                cell.issuedDateLabel.text = showIndex[7]
                cell.documentImageView.image = #imageLiteral(resourceName: "icon")
                
                cell.layer.cornerRadius = 6
                cell.layer.shadowColor = UIColor.gray.cgColor
                cell.layer.shadowOffset = CGSize(width: -2.0, height: 2.0)
                cell.layer.shadowRadius = 2.0
                cell.layer.shadowOpacity = 0.5
                cell.layer.masksToBounds = false
                cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
            }
            return cell
        }
        else {
            //MARK: 0:병명,1:소견,2:비고,3:병원이름,4:전화번호,5:의사면허,6:의사이름,7:방문시간
            let index = totalMedicalRecordData[indexPath.row]
            let cell = visitRecordCollectionView.dequeueReusableCell(withReuseIdentifier: "VisitRecordCell", for: indexPath) as! VisitRecordCell
            cell.hospitalNameLabel.text = index[3]
            cell.diseaseNameLabel.text = index[0]
            cell.visitingDateLabel.text = index[7]
            
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == medicalRecordCollectionView {
            let showIndex = showMedicalRecordData[indexPath.row]
            guard let detailVC = storyboard?.instantiateViewController(
                withIdentifier : "DetailMedicalRecordVC"
                ) as? DetailMedicalRecordVC
                else{return}
            detailVC.medicalRecordData = showIndex
            self.present(detailVC, animated: true, completion: nil)
        } else {
            let index = totalMedicalRecordData[indexPath.row]
            guard let issueVC = storyboard?.instantiateViewController(
                withIdentifier : "IssueMedicalRecordVC"
                ) as? IssueMedicalRecordVC
                else{return}
            issueVC.diseaseName = index[0]
            issueVC.hospitalName = index[3]
            issueVC.paidMedicalRecordData = index
            self.present(issueVC, animated: true, completion: nil)
        }
    }
}
