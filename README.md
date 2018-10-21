# # Dr.CRYPTO

블록체인을 활용한 의료 기록 관리 애플리케이션

데모영상 : <https://youtu.be/Oz8dfvZYVcw>


## # 개요

이더리움 블록체인 네트워크(Rinkeby)를 이용해 언제 어디서든 개인 진단서를 안전하게 발급받고, 타 의료기관으로 전송할 수 있는 애플리케이션


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
                print("keystore",keystore!)
                ks = keystore
                //   ks = try EthereumKeystoreV3(password: pass ?? "")
                let keydata = try JSONEncoder().encode(ks?.keystoreParams)
                FileManager.default.createFile(atPath: userDir + "/keystore"+"/key.json", contents: keydata, attributes: nil)
                print(userDir)
                
            } else {
                ks = keystoreManager?.walletForAddress((keystoreManager?.addresses![0])!) as? BIP32Keystore
            }
~~~


* 병원 진단서 발급

* 타 의료기관으로 전송


## # 스크린샷

<img src = "/image/drcrypto_1.png">
<img src = "/image/drcrypto_2.png">