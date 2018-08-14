//
//  AccountVC.swift
//  DrCRYPTO
//
//  Created by 갓거 on 2018. 8. 10..
//  Copyright © 2018년 Dr.CRYPTO. All rights reserved.
//

import UIKit
import FirebaseAuth

class AccountVC : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func logout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let loginStoryboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
            let viewController = loginStoryboard.instantiateViewController(withIdentifier: "NavigaionVC") as! NavigaionVC
            UIApplication.shared.keyWindow?.rootViewController = viewController
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    
}
