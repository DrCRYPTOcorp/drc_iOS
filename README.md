# # Dr.CRYPTO

블록체인을 활용한 의료 기록 관리 애플리케이션

데모영상 : <https://youtu.be/Oz8dfvZYVcw>


## # 개요

이더리움 블록체인 네트워크(Rinkeby)와 Google Firebase를 이용해 언제 어디서든 개인 진단서를 안전하게 발급받고, 타 의료기관으로 전송할 수 있는 애플리케이션


## # 주요기능

* 개인 의료 지갑 생성
	* 회원가입시 KeystoreManager와 FileManager를 활용하여 유저 디바이스 내에 진단서를 저장, 관리 할 개인 지갑 생성
~~~
let userDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
let keystoreManager = KeystoreManager.managerForPath(userDir + "/keystore")
var ks: BIP32Keystore?

if (keystoreManager?.addresses?.count == 0) {
    let password = gsno(confirmPasswordTextField.text)
    let mnemonic = try! BIP39.generateMnemonics(bitsOfEntropy: 256)!
    let keystore = try! BIP32Keystore(mnemonics: mnemonic, password: password, mnemonicsPassword: String((password).reversed()))
    ks = keystore
    let keydata = try JSONEncoder().encode(ks?.keystoreParams)
    FileManager.default.createFile(atPath: userDir + "/keystore"+"/key.json", contents: keydata, attributes: nil)      
} else {
    ks = keystoreManager?.walletForAddress((keystoreManager?.addresses![0])!) as? BIP32Keystore
}
~~~


* 병원 진단서 발급
	* 발급 받고 싶은 방문 기록을 클릭하여 Dr.CRYPTO 자체 토큰인 DRC로 결제를 하게 되면 트랜잭션을 발생시켜 결제 승인시 진단서를 개인 의료 지갑으로 발급.
	* 아래는 web3swift를 사용하여 ERC20ABI의 Trasfer 메소드를 호출하여 결제 트랜잭션을 보내는 코드.
	* iOS GCD 클래스의 DispatchQueue를 사용하여 트랜잭션 시 블록에 기록될 때까지 메인 스레드를 점유하여 UI가 적용되지 않는 이슈를 해결.
```
let testToken = web3Rinkeby?.contract(Web3.Utils.erc20ABI, at: EthereumAddress("0xdf88d798e9f9b916c25db739b939a27d8f80c0ad")!, abiVersion: 2)!
let intermediateForTokenTransfer = testToken?.method("transfer", parameters: [EthereumAddress("0x9807142b04b0c378e2f750762cd2384040509a5a")!, BigUInt(30)] as [AnyObject], options: tokenTransferOptions)!
let gasEstimateResult = intermediateForTokenTransfer?.estimateGas(options: nil)
        
//MARK: Rinkeby Gas Estimate
guard case .success(let gasEstimate)? = gasEstimateResult else {return}
var optionsWithCustomGasLimit = Web3Options()
optionsWithCustomGasLimit.gasLimit = gasEstimate
let tokenTransferResult = intermediateForTokenTransfer?.send(password: gsno(userPassword), options: optionsWithCustomGasLimit)
        
//MARK: Token Transfer Result
switch tokenTransferResult {
	case .success(let res)?:
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
}
```

* 타 의료기관으로 전송


## # 스크린샷

<img src = "/image/drcrypto_1.png">
<img src = "/image/drcrypto_2.png">