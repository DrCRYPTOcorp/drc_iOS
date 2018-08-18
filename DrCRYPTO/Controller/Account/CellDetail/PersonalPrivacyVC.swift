//
//  PersonalPrivacyVC.swift
//  DrCRYPTO
//
//  Created by 갓거 on 2018. 8. 18..
//  Copyright © 2018년 Dr.CRYPTO. All rights reserved.
//

import UIKit

class PersonalPrivacyVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarSetting()
    }
}

extension PersonalPrivacyVC {
    
    func navigationBarSetting(){
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "NanumBarunGothicBold", size: 16)!]
    }
}
