//
//  IssueMedicalRecordVC.swift
//  DrCRYPTO
//
//  Created by 갓거 on 2018. 8. 18..
//  Copyright © 2018년 Dr.CRYPTO. All rights reserved.
//

import UIKit
import web3swift
import BigInt
import FirebaseDatabase

class IssueMedicalRecordVC: UIViewController {

    @IBOutlet var hospitalNameLabel: UILabel!
    @IBOutlet var diseaseNameLabel: UILabel!
    @IBOutlet var myAddressLabel: UILabel!
    @IBOutlet var costLabel: UILabel!
    @IBOutlet var payButton: UIButton!
    
    @IBOutlet var grayViewButton: UIButton!
    @IBOutlet var doneView: UIView!
    @IBOutlet var centerYconstraint: NSLayoutConstraint!
    
    
    let ud = UserDefaults.standard
    var userAddress : String?
    var userPassword: String?
    var diseaseName: String?
    var hospitalName : String?
    var paidMedicalRecordData = [String]()
    
    var indicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var web3Rinkeby:web3?
    var bip32keystore:BIP32Keystore?
    var keystoremanager:KeystoreManager?
    var contract:web3.web3contract?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userAddress = ud.string(forKey: "address")
        userPassword = ud.string(forKey: "password")
        
        let accessToken : String = "7600d818c4084a56953378cdf14a15df"
        web3Rinkeby = Web3.InfuraRinkebyWeb3(accessToken: accessToken)
        let userDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let path = userDir+"/keystore/"
        keystoremanager =  KeystoreManager.managerForPath(path, scanForHDwallets: true, suffix: "json")
        self.web3Rinkeby?.addKeystoreManager(self.keystoremanager)
        self.bip32keystore = self.keystoremanager?.bip32keystores[0]
        
        setting()
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension IssueMedicalRecordVC {
    func setting(){
        doneView.layer.cornerRadius = 8
        grayViewButton.isHidden = true
        myAddressLabel.text = gsno(userAddress)
        costLabel.text = "30 DRC"
        hospitalNameLabel.text = gsno(hospitalName)
        diseaseNameLabel.text = gsno(diseaseName)
        payButton.addTarget(self, action: #selector(payButtonAction), for: .touchUpInside)
    }
    
    @objc func payButtonAction(){
        grayViewButton.isHidden = false
        indicatorSetting()
        grayViewButton.addSubview(indicator)
        indicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            self.transaction()
        }
    }
    
    //MARK: Indicator Setting
    func indicatorSetting(){
        indicator.frame = CGRect(x: 0.0, y: 0.0, width: 40, height: 40)
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        indicator.center = CGPoint(x: grayViewButton.frame.size.width / 2, y: grayViewButton.frame.size.height / 2)
    }
    
    //MARK: 트랜잭션 실패 Alert
    func transactionFailAlert(){
        let alert = UIAlertController(title: "트랜잭션 오류", message: "토큰 및 이더 보유량을 확인해주세요.", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "확인", style: .cancel) { (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okayAction)
        present(alert, animated: true)
    }
    
    func transaction(){
        
        //MARK: Rinkeby Gas Price
        guard case .success(let gasPriceRinkeby)? = web3Rinkeby?.eth.getGasPrice() else {return}
        web3Rinkeby?.addKeystoreManager(keystoremanager)
        var tokenTransferOptions = Web3Options.defaultOptions()
        tokenTransferOptions.gasPrice = 1000000000 * 20
        tokenTransferOptions.from = EthereumAddress(gsno(userAddress))
        let testToken = web3Rinkeby?.contract(Web3.Utils.erc20ABI, at: EthereumAddress("0xb688b7fa446adcb0318938729fc012967bc9d665")!, abiVersion: 2)!
        let intermediateForTokenTransfer = testToken?.method("transfer", parameters: [EthereumAddress("0x8eb78ef217596fb5b9b94fb88add9093c925b85e")!, BigUInt(30)] as [AnyObject], options: tokenTransferOptions)!
        let gasEstimateResult = intermediateForTokenTransfer?.estimateGas(options: nil)
        
        //MARK: Rinkeby Gas Estimate
        guard case .success(let gasEstimate)? = gasEstimateResult else {return}
        var optionsWithCustomGasLimit = Web3Options()
        optionsWithCustomGasLimit.gasLimit = gasEstimate
        let tokenTransferResult = intermediateForTokenTransfer?.send(password: gsno(userPassword), options: optionsWithCustomGasLimit)
        
        //MARK: Token Transfer Result
        switch tokenTransferResult {
        case .success(let res)?:
            print(res)
            indicator.stopAnimating()
            //MARK: 결제 완료 Animation View
            self.centerYconstraint.constant = 0
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            })
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                NotificationCenter.default.post(name: .paidMedicalRecordNoti, object: nil, userInfo: ["index" : self.paidMedicalRecordData])
                self.dismiss(animated: true, completion: nil)
            }
        case .failure(let error)?:
            print(error)
            indicator.stopAnimating()
            transactionFailAlert()
            
        case .none:
            print("nothing")
            indicator.stopAnimating()
            transactionFailAlert()
        }
    }
}
