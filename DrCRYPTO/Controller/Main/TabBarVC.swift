//
//  TabBarVC.swift
//  DrCRYPTO
//
//  Created by 갓거 on 2018. 8. 14..
//  Copyright © 2018년 Dr.CRYPTO. All rights reserved.
//

import UIKit

class TabBarVC : UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TabBar tint 값 제거 및 이미지 적용
//        UITabBar.appearance().barTintColor = UIColor.init()
        let tabBar = self.tabBar
        let walletImage = UIImage(named:"wallet_active")?.withRenderingMode(.alwaysOriginal)
        let transactionImage = UIImage(named: "transaction_active")?.withRenderingMode(.alwaysOriginal)
        let accountImage = UIImage(named: "account_active")?.withRenderingMode(.alwaysOriginal)
        
//        let walletInActiveImage = UIImage(named:"wallet_inactive")?.withRenderingMode(.alwaysOriginal)
//        let transactionInActiveImage = UIImage(named: "transaction_inactive")?.withRenderingMode(.alwaysOriginal)
//        let accountInActiveImage = UIImage(named: "account_inactive")?.withRenderingMode(.alwaysOriginal)
        
        (tabBar.items![0] ).selectedImage = walletImage
        (tabBar.items![1] ).selectedImage = transactionImage
        (tabBar.items![2] ).selectedImage = accountImage
        

        
    }
    
}
