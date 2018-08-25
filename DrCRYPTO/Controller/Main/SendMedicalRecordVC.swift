//
//  SendMedicalRecordVC.swift
//  DrCRYPTO
//
//  Created by 갓거 on 2018. 8. 18..
//  Copyright © 2018년 Dr.CRYPTO. All rights reserved.
//

import UIKit
import Hero
import AVFoundation
import QRCodeReader
import web3swift
import BigInt

class SendMedicalRecordVC : UIViewController {
    
    @IBOutlet var grayViewButton: UIButton!
    @IBOutlet var hospitalNameLabel: UILabel!
    @IBOutlet var diseaseNameLabel: UILabel!
    @IBOutlet var toAddressTextfield: UITextField!
    @IBOutlet var myAddressLabel: UILabel!
    @IBOutlet var qrCodeButton: UIButton!
    @IBOutlet var costLabel: UILabel!
    @IBOutlet var payButton: UIButton!
    @IBOutlet var centerYconstraint: NSLayoutConstraint!
    @IBOutlet var doneView: UIView!
    
    
    var diseaseName : String?
    var hospitalName : String?
    var toAddress : String?
    
    var userAddress : String?
    var userPassword: String?
    let ud = UserDefaults.standard
    
    var indicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var web3Rinkeby:web3?
    var bip32keystore:BIP32Keystore?
    var keystoremanager:KeystoreManager?
    var contract:web3.web3contract?
    
    lazy var reader: QRCodeReader = QRCodeReader()
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader                  = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            $0.showTorchButton         = true
            $0.preferredStatusBarStyle = .lightContent
            
            $0.reader.stopScanningWhenCodeIsFound = false
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        payButton.isEnabled = false
        doneView.layer.cornerRadius = 8
        payButton.addTarget(self, action: #selector(transactionButtonAction), for: .touchUpInside)
        userAddress = ud.string(forKey: "address")
        userPassword = ud.string(forKey: "password")
        grayViewButton.isHidden = true
        let accessToken : String = "7600d818c4084a56953378cdf14a15df"
        web3Rinkeby = Web3.InfuraRinkebyWeb3(accessToken: accessToken)
        let userDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let path = userDir+"/keystore/"
        keystoremanager =  KeystoreManager.managerForPath(path, scanForHDwallets: true, suffix: "json")
        self.web3Rinkeby?.addKeystoreManager(self.keystoremanager)
        self.bip32keystore = self.keystoremanager?.bip32keystores[0]
        
        diseaseNameLabel.text = gsno(diseaseName)
        hospitalNameLabel.text = gsno(hospitalName)
        myAddressLabel.text = gsno(ud.string(forKey: "address"))
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        hero.unwindToRootViewController()
    }
    
    @IBAction func scanQRcodeAction(_ sender: Any) {
        guard checkScanPermissions() else { return }
        
        readerVC.modalPresentationStyle = .formSheet
        readerVC.delegate               = self
        
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            if let result = result {
                print("Completion with result: \(result.value) of type \(result.metadataType)")
            }
        }
        
        present(readerVC, animated: true, completion: nil)
    }
    
    //MARK: Indicator Setting
    func indicatorSetting(){
        indicator.frame = CGRect(x: 0.0, y: 0.0, width: 40, height: 40)
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        indicator.center = CGPoint(x: grayViewButton.frame.size.width / 2, y: grayViewButton.frame.size.height / 2)
    }
    
    @objc func transactionButtonAction(){
        print(toAddressTextfield.text)
        if toAddressTextfield.text != nil{
            grayViewButton.isHidden = false
            indicatorSetting()
            grayViewButton.addSubview(indicator)
            indicator.startAnimating()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                self.transaction()
            }
        } else{
            simpleAlert(title: "보낼 지갑 주소 오류", msg: "보낼 지갑 주소를 입력해주세요.")
        }
    }
    
    func transaction(){
        //MARK: Rinkeby Gas Price
        guard case .success(let gasPriceRinkeby)? = web3Rinkeby?.eth.getGasPrice() else {return}
        web3Rinkeby?.addKeystoreManager(keystoremanager)
        var tokenTransferOptions = Web3Options.defaultOptions()
        tokenTransferOptions.gasPrice = 1000000000 * 20
        tokenTransferOptions.from = EthereumAddress(gsno(userAddress))
        
        let testToken = web3Rinkeby?.contract(Web3.Utils.erc20ABI, at: EthereumAddress("0xb688b7fa446adcb0318938729fc012967bc9d665")!, abiVersion: 2)!
        let intermediateForTokenTransfer = testToken?.method("transfer", parameters: [EthereumAddress(gsno(toAddress))!, BigUInt(2)] as [AnyObject], options: tokenTransferOptions)!
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
            NotificationCenter.default.post(name: .updateTransactionNoti, object: nil, userInfo: ["hospitalName":gsno(hospitalName), "diseaseName": gsno(diseaseName)])
            //MARK: 결제 완료 Animation View
            self.centerYconstraint.constant = 0
            UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            })
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
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
    
    //MARK: 트랜잭션 실패 Alert
    func transactionFailAlert(){
        let alert = UIAlertController(title: "트랜잭션 오류", message: "토큰 및 이더 보유량을 확인해주세요.", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "확인", style: .cancel) { (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okayAction)
        present(alert, animated: true)
    }
    
}

extension SendMedicalRecordVC : QRCodeReaderViewControllerDelegate{
    
    private func checkScanPermissions() -> Bool {
        do {
            return try QRCodeReader.supportsMetadataObjectTypes()
        } catch let error as NSError {
            let alert: UIAlertController
            
            switch error.code {
            case -11852:
                alert = UIAlertController(title: "Error", message: "This app is not authorized to use Back Camera.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
                    DispatchQueue.main.async {
                        if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                            UIApplication.shared.openURL(settingsURL)
                        }
                    }
                }))
                
                alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            default:
                alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
            }
            
            present(alert, animated: true, completion: nil)
            
            return false
        }
    }
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        toAddress = result.value
        toAddressTextfield.text = result.value
        payButton.isEnabled = true
        dismiss(animated: true)
    }
    
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        print("Switching capturing to: \(newCaptureDevice.device.localizedName)")
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
    
}
