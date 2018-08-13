//
//  SplashVC.swift
//  DrCRYPTO
//
//  Created by 갓거 on 2018. 8. 10..
//  Copyright © 2018년 Dr.CRYPTO. All rights reserved.
//

import UIKit

class SplashVC : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            UIApplication.shared.keyWindow?.rootViewController = viewController
        }
    }
}
